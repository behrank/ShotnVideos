//
//  Procotols.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 25.05.2021.
//

import Foundation
import RealmSwift

protocol Worker {
    var onDataFetchedAction: (()->Void)? { get set }
    var onDataUpdatedAction: (()->Void)? { get set }
    var onErrorAction: ((String)->Void)? { get set }
}

protocol NetworkWorker: Worker {
    func fetchDataFor(_ target: NetworkTarget)
}

protocol RealmWorker: Worker {
    var realm: Realm?                    { get set }
    var notification: NotificationToken? { get set }

    func fetchObjectsFromDb()
    func getObjectAt(index: Int) -> Object?
    func getObjectCount() -> Int
    func prepareNotification()
}
