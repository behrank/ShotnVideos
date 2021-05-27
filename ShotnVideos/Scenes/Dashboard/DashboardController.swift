//
//  DashboardController.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 24.05.2021.
//

import UIKit

class DashboardController: CollectionController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Users"
        
        prepareWorker()
        setupCollectionView()
        displayLoading()
        
        Queue.main.executeAfter(delay: .oneSecond) { [weak self] in
            self?.worker?.fetchDataFor(.fetchVideos)
        }
    }
    
    // MARK: - Collection
    override func setupCollectionView() {
        super.setupCollectionView()
        
        collection.dataSource = self
        collection.delegate = self
        collection.register(UserCell.self, forCellWithReuseIdentifier: ShotnVideo.Cell.userCell.reuseId)
    }
    
    // MARK: - Data
    var worker: DashboardWorker?

    private func prepareWorker() {
        worker = DashboardWorker()
        worker?.onDataFetchedAction = onDataReadyAction
        worker?.onDataUpdatedAction = onDataUpdatedAction
        worker?.onErrorAction = presentError(_:)
    }
}

// MARK: - Collection Stuff
extension DashboardController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return worker?.getObjectCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShotnVideo.Cell.userCell.reuseId, for: indexPath) as? UserCell,
              let user = worker?.getObjectAt(index: indexPath.row) as? UserObject else {
            return UICollectionViewCell()
        }
        
        cell.setupWith(user: user)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let user = worker?.getObjectAt(index: indexPath.row) as? UserObject {
            let shotsVc = Scene.shots(user)
            moveToScene(shotsVc, type: .show)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return ShotnVideo.Cell.userCell.frame
    }
}
