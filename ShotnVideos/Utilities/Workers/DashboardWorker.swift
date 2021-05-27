//
//  DashboardWorker.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 25.05.2021.
//

import Foundation
import RealmSwift

class DashboardWorker: NetworkWorker, RealmWorker {
    
    var onDataFetchedAction: (()->Void)?
    var onDataUpdatedAction: (()->Void)?
    var onErrorAction: ((String)->Void)?
    
    init() {
        Queue.main.execute {
            do {
                self.realm = try Realm()
                self.prepareNotification()
                
            } catch (_) {
                debugPrint("Realm cannot perform.")
            }
        }
    }
    
    func fetchDataFor(_ target: NetworkTarget) {
        
        target.call { [weak self] (response: ShotsFetchResponse?) in
            
            guard let result = response else {
                self?.onErrorAction?(FetchResult.unexpectedError.message)
                return
            }
            
            if result.success ?? false {
                
                Queue.main.execute {
                    self?.fetchObjectsFromDb()
                    self?.saveObjects(result.data)
                }
                
            } else {
                self?.onErrorAction?(FetchResult.unexpectedError.message)
            }
            
        } failureCompletion: { [weak self] fetchResult in
            self?.onErrorAction?(fetchResult.message)
        }
    }
    
    // MARK: - Realm
    var realm: Realm?
    var notification: NotificationToken?
    
    private var databaseData: Results<UserObject>?
    
    func prepareNotification() {
        fetchObjectsFromDb()
        
        notification = databaseData?.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial:
                debugPrint("objects populated")
                
                self?.fetchObjectsFromDb()
                
                if self?.databaseData?.count ?? 0 > 0 {
                    self?.onDataFetchedAction?()
                }
                
            case .update(_, let deletions, let insertions, let modifications):
                if deletions.count > 0 {
                    debugPrint("objects deleted")
                }
                
                if insertions.count > 0 {
                    debugPrint("objects inserted")
                    
                    self?.fetchObjectsFromDb()
                    self?.onDataFetchedAction?()
                }
                
                if modifications.count > 0 {
                    self?.onDataUpdatedAction?()
                    debugPrint("objects updated")
                }
                
            case .error(let error):
                fatalError("\(error)")
            }
        }
    }
    
    func fetchObjectsFromDb() {
        databaseData = realm?.objects(UserObject.self)
    }
    
    func getObjectAt(index: Int) -> Object? {
        return databaseData?[index]
    }
    
    func getObjectCount() -> Int {
        return databaseData?.count ?? 0
    }
    
    // MARK: - Private funcs
    private func saveObjects(_ data: [Decodable]?) {
        
        guard let dataFromNetwork = data as? [ShotsData] else {
            return
        }
        
        var realmData: [UserObject] = []
        
        for item in dataFromNetwork {
            
            let user = UserObject()
            user.name = item.user?.name ?? ""
            user.surname = item.user?.surname ?? ""
            
            if let dbData = databaseData {
                let existingItem = dbData.first(where: { (usr: UserObject) -> Bool in
                    return  user.getFullName() == usr.getFullName()
                })
                
                if existingItem == nil {
                    
                    if let shots = item.shots {
                        for shotItem in shots {

                            let shot = ShotObject()
                            shot.id = shotItem.id ?? ""
                            shot.inOut = shotItem.inOut ?? false
                            shot.point = shotItem.point ?? 0
                            shot.segment = shotItem.segment ?? 0
                            shot.shotPosX = shotItem.shotPosX ?? 0
                            shot.shotPosY = shotItem.shotPosY ?? 0
                            
                            user.shots.append(shot)
                        }
                    }
                    
                    realmData.append(user)
                }
            }
        }
        
        if realmData.count > 0 {
            Queue.main.execute { [weak self] in
                try! self?.realm?.write {
                    self?.realm?.add(realmData)
                }
            }
        }
    }
    private func deletePreviousObjects() {
        
        let users = realm?.objects(UserObject.self)
        
        guard let storedUsers = users else {
            return
        }
        
        try! realm?.write {
            realm?.delete(storedUsers)
        }
    }
    
    deinit {
        notification = nil
    }
}
