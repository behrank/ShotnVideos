//
//  ChartController.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 24.05.2021.
//

import UIKit

class ChartController: CollectionController {
    
    lazy private var chartView: ChartView = {
        return ChartView()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Chart"
        
        view.addSubviews(views: chartView)
        chartView.setMargins(.top(value: 8),
                             .left(value: 8),
                             .right(value: 8))
        chartView.setHeight(view.frame.height / 2)
        
        prepareWorker()
        setupCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        worker?.fetchObjectsFromDb()
    }
    
    // MARK: - Collection
    override func setupCollectionView() {
        view.addSubviews(views: collection)
        collection.setMargins(.bottom(value: 0),
                              .right(value: 0),
                              .left(value: 0))
        
        collection.setMarginTo(view: chartView,
                               with: .bottom(value: 12))
        collection.backgroundColor = .clear

        collection.dataSource = self
        collection.delegate = self
        collection.isHidden = true
        collection.register(UserCell.self, forCellWithReuseIdentifier: ShotnVideo.Cell.userCell.reuseId)
    }
    
    // MARK: - Data
    var worker: ChartWorker?

    private func prepareWorker() {
        worker = ChartWorker()
        worker?.onDataFetchedAction = onDataReadyAction
        worker?.onDataUpdatedAction = onDataUpdatedAction
        worker?.onErrorAction = presentError(_:)
    }
    
    override func onDataReadyAction() {
        super.onDataReadyAction()
        collection.isHidden = false
        
        guard let user = worker?.getObjectAt(index: 0) as? UserObject else {
            return
        }
        chartView.prepareChartFor(user: user)
        
        updateTitle(user.getFullName())
    }
    
    private func updateTitle(_ title: String) {
        self.title = "Chart - \(title)"
        navigationController?.title = "Chart"
    }
}

// MARK: - Collection Stuff
extension ChartController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
            chartView.prepareChartFor(user: user)
            
            updateTitle(user.getFullName())
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return ShotnVideo.Cell.userCell.frame
    }
}
