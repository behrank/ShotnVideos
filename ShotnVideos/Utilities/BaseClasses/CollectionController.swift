//
//  CollectionController.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 25.05.2021.
//

import UIKit
import RacoonKit

class CollectionController: BaseController {
    
    // MARK: - Collection View
    lazy internal var collection: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 2
        
        var collection = UICollectionView(frame: .zero,
                                          collectionViewLayout: layout)
        
        collection.backgroundColor = .systemBackground
        return collection
    }()
    
    internal func setupCollectionView() {
        view.addSubviews(views: collection)
        
        collection.fillSuperview()
        collection.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
        
        collection.backgroundColor = .clear
        collection.isHidden = true
    }
    
    // MARK: - Actions
    func onDataReadyAction() {
        Queue.main.execute { [weak self] in
            self?.hideLoading()
            
            self?.collection.reloadData()
            self?.collection.isHidden = false
        }
    }
    
     func onDataUpdatedAction() {
        Queue.main.execute { [weak self] in
            
            guard let visibleCells = self?.collection.indexPathsForVisibleItems else {
                return
            }
            
            self?.collection.reloadItems(at: visibleCells)
        }
    }
}
