//
//  ShotsController.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 25.05.2021.
//

import UIKit

class ShotsController: CollectionController {
    
    private var currentUser: UserObject?
    
    init(user: UserObject) {
        super.init(nibName: nil, bundle: nil)
        
        currentUser = user
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Shots"
        
        prepareWorker()
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Queue.main.execute {
            self.collection.reloadData()
        }
    }
    
    // MARK: - Collection
    override func setupCollectionView() {
        super.setupCollectionView()
        
        collection.dataSource = self
        collection.delegate = self
        collection.register(ShotCell.self,
                            forCellWithReuseIdentifier: ShotnVideo.Cell.shotCell.reuseId)
        collection.isHidden = false
        collection.contentInset = UIEdgeInsets(top: 10,
                                               left: 10,
                                               bottom: 10,
                                               right: 10)
    }
    
    // MARK: - Data
    var worker: ShotsWorker?

    private func prepareWorker() {
        
        guard let currentUser = currentUser else {
            return
        }
        
        worker = ShotsWorker(user: currentUser)
        
        worker?.onDataFetchedAction = onDataReadyAction
        worker?.onDataUpdatedAction = onDataUpdatedAction
        worker?.onErrorAction = presentError(_:)
    }
    
    // MARK: - Actions
    private func onPlayButtonTapped(shot: ShotObject) {
        debugPrint("Play tapped")
        
        if shot.hasVideo {
            let videoPlayer = VideoPlayerView()
            videoPlayer.setup(for: shot, isCloseRequired: true)
            videoPlayer.display()
            
        } else {
            moveToScene(.camera(shot),
                        type: .replace)
        }
    }
}

// MARK: - Collection Stuff
extension ShotsController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return worker?.getObjectCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShotnVideo.Cell.shotCell.reuseId, for: indexPath) as? ShotCell,
              let shot =  worker?.getObjectAt(index: indexPath.row) as? ShotObject
        else {
            return UICollectionViewCell()
        }
        cell.setupWith(shot: shot)
        cell.onPlayButtonTapped = onPlayButtonTapped
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return ShotnVideo.Cell.shotCell.frame
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
}
