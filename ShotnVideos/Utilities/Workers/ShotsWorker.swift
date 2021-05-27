//
//  ShotsWorker.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 25.05.2021.
//

import Foundation
import RealmSwift

class ShotsWorker: RealmWorker {
    var onDataFetchedAction: (() -> Void)?
    var onDataUpdatedAction: (() -> Void)?
    var onErrorAction: ((String) -> Void)?
    
    init(user: UserObject) {
        databaseData = user
        
        Queue.main.execute {
            do {
                self.realm = try Realm()
            } catch (_) {
                debugPrint("Realm cannot perform.")
            }
        }
    }
    
    // MARK: - Realm    
    var realm: Realm?
    var notification: NotificationToken?
    
    private var userIndex: Int = 0
    private var databaseData: UserObject?
    
    func prepareNotification() {
        notification = databaseData?.observe { change in
            switch change {
            case .change(_, let properties):
                for _ in properties {
                    debugPrint("Object changed")
                }
            case .error(let error):
                debugPrint("An error occurred: \(error)")
            case .deleted:
                debugPrint("The object was deleted.")
            }
        }
    }
    
    func fetchObjectsFromDb() {
        // No need to implement
    }

    func getObjectAt(index: Int) -> Object? {
        return databaseData?.shots[index]
    }
    
    func getObjectCount() -> Int {
        return databaseData?.shots.count ?? 0
    }
    
    deinit {
        notification = nil
    }
}
