//
//  ChartWorker.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 27.05.2021.
//

import Foundation
import RealmSwift

class ChartWorker:RealmWorker {
    
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
                self?.onDataFetchedAction?()
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
    
    deinit {
        notification = nil
    }
}
