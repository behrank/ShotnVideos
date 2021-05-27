//
//  BaseController.swift
//  ShotnVideos
//
//  Created by Behran Kankul on 25.05.2021.
//

import UIKit

class BaseController: UIViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        
        setupActivityIndicator()
    }
    
    // MARK: - Loading
    lazy private var indicator: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(frame: .zero)
        activityView.hidesWhenStopped = true
        activityView.color = .label
        activityView.style = .medium
        return activityView
    }()
    
    private func setupActivityIndicator() {
        view.addSubviews(views: indicator)
        
        indicator.setMargins(.top(value: 64))
        indicator.anchorCenterXToSuperview()
        
        indicator.setWidth(28)
        indicator.setHeight(28)
        
        indicator.stopAnimating()
    }
    
    func displayLoading() {
        Queue.main.execute { [weak self] in
            self?.indicator.startAnimating()
        }
    }
    func hideLoading() {
        Queue.main.execute { [weak self] in
            self?.indicator.stopAnimating()
        }
    }
    
    @objc func back() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Error
    func presentError(_ errMessage: String) {
        let alertController = UIAlertController(title: "ShotnVideos",
                                                      message: errMessage,
                                                      preferredStyle: .alert)

        let defaultAction = UIAlertAction(title: "OK",
                                           style: .default,
                                           handler: nil)
        
        alertController.addAction(defaultAction)

        Queue.main.execute { [weak self] in
            self?.present(alertController,
                         animated: true,
                         completion: {
                            if self?.indicator.isAnimating ?? false {
                                self?.hideLoading()
                            }
                         })
        }
    }
    
    // MARK: - Keyboard
    func addHideKeyboard() {
        let hideKeyboardGesture = UITapGestureRecognizer(target: self,
                                                         action: #selector(handleKeyboardHide))
        hideKeyboardGesture.cancelsTouchesInView = false
        
        view.addGestureRecognizer(hideKeyboardGesture)
    }
    
    @objc private func handleKeyboardHide() {
        view.endEditing(true)
    }
    
    // MARK: - Generic Routing
    func moveToScene(_ scene: Scene, type: SegueType) {
        switch type {
        case .show: routeToScene(scene, isSubScene: true)
        case .modal:
            if #available(iOS 13.0, *) {
                routeModalyToScene(scene, presentation: .automatic)
            } else {
                // Fallback on earlier versions
                routeModalyToScene(scene, presentation: .fullScreen)
            }
        case .replace: routeModalyToScene(scene, presentation: .fullScreen)
        }
    }
    
    @objc func dismissCurrentScene() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissCurrentSceneDelayed() {
        Queue.main.executeAfter(delay: DelayTime.customMiliseconds(200)) {
            self.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - Private
fileprivate extension BaseController {
    
    func routeToScene(_ scene: Scene, isSubScene: Bool = true) {

        let vc = scene.viewController
        vc.hidesBottomBarWhenPushed = isSubScene
        
        Queue.main.execute {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func routeModalyToScene(_ scene: Scene, presentation: UIModalPresentationStyle) {
        Queue.main.execute {
            let vc = scene.viewController
            vc.modalPresentationStyle = presentation
            vc.modalPresentationCapturesStatusBarAppearance = true
            
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
    }
}
