//
//  WatchListStatusIndicator.swift
//  MyMovies
//

import Foundation
import UIKit

enum AddToWatchListState {
    case addMovieToWatchList
    case addTVShowToWatchList
    case removeFromWatchList
}

final class WatchListStatusIndicator: NSObject {
    
    // Is the indicator being shown
    
    private(set) var isShowing: Bool = false
    
    // Content vertical inset
    private var verticalInset: NSLayoutConstraint?
    
    
    // Singleton
    static let shared = WatchListStatusIndicator()
    
    // View
    
    private lazy var myWindow: UIWindow = {
        let window = UIWindow()
        window.windowLevel = UIWindow.Level.statusBar + 1
        window.backgroundColor = .clear
        window.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 70)
        return window
    }()
    
    private lazy var closeButton: CustomButton = {
        let btn = CustomButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "cancel-music").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleCloseIndicator), for: .touchUpInside)
        btn.contentMode = .scaleAspectFit
        btn.clipsToBounds = true
        return btn
    }()
    
    private lazy var statusText: CustomLabel = {
        let lbl = CustomLabel()
        lbl.text = ""
        lbl.font = UIFont(name: "Avenir-Heavy", size: 15)
        lbl.textColor = .white
        lbl.textAlignment = .center
        return lbl
    }()
    
    private lazy var containerView: UIView = {
        let container = UIView()
        container.backgroundColor = .clear
        return container
    }()
    
    // Init
    override init() {
        super.init()
        
        setupViews()
    }
    
    // MARK: Usage methods
    
    func showIndicator(state: AddToWatchListState) {
        if (!isShowing) {
            
            isShowing = true
            
            myWindow.isHidden = false
            self.containerView.alpha = 0
            self.closeButton.alpha = 0
            
            switch state {
            case .addMovieToWatchList:
                self.containerView.backgroundColor = UIColor.movieTintColor()
                self.statusText.text = "Added to watchlist".uppercased()
            case .addTVShowToWatchList:
                self.containerView.backgroundColor = UIColor.tvShowTintColor()
                self.statusText.text = "Added to watchlist".uppercased()
            case .removeFromWatchList:
                self.containerView.backgroundColor = UIColor.red
                self.statusText.text = "Removed from watchlist".uppercased()
            }
            
            UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                
                self.containerView.alpha = 1
                self.closeButton.alpha = 1
                
            }, completion: { (_) in
                // Handle dismiss the indicator
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {[weak self] in
                    self?.dismiss()
                })
            })
            
            
        }
    }
    
    // MARK: Private methods
    
    private func setupViews() {
        
        if !myWindow.subviews.contains(containerView) {
            myWindow.addSubview(containerView)
        }
        
        containerView.anchor(top: myWindow.topAnchor, left: myWindow.leftAnchor, bottom: nil, right: myWindow.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 70)
        
        if !containerView.subviews.contains(statusText) {
            containerView.addSubview(statusText)
        }
        
        statusText.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 0)
        
        if !containerView.subviews.contains(closeButton) {
            containerView.addSubview(closeButton)
        }
        
        closeButton.anchor(top: containerView.topAnchor, left: nil, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 50, height: 50)
    }
    
    fileprivate func dismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.containerView.alpha = 0
            self.statusText.text = ""
            self.closeButton.alpha = 0
        }) { (_) in
            // Clear up
            self.myWindow.isHidden = true
            self.isShowing = false
        }
    }
    
    @objc fileprivate func handleCloseIndicator() {
        print("Close indicator")
        
        self.dismiss()
    }
}
