//
//  MyRatingViewController.swift
//  MyMovies

import Foundation
import UIKit
import PageMenu

class MyRatingViewController: UIViewController {
    
    var pageMenu: CAPSPageMenu?
    var controllerArray : [UIViewController] = []
    
    let myRatingTitle: CustomLabel = {
        let label = CustomLabel(frame: .zero, topInset: 0, bottomInset: 0, leftInset: 0, rightInset: 0)
        label.addCharactersSpacing(spacing: 5, text: "RATINGS")
        label.font = UIFont(name: "Avenir-Heavy", size: 17)
        label.textColor = UIColor.userProfileTintColor()
        label.textAlignment = .center
        return label
    }()
    
    let movieVC: MyMovieRatingViewController = {
        let layout = UICollectionViewFlowLayout()
        let vc = MyMovieRatingViewController(collectionViewLayout: layout)
        vc.title = "Movies"
        return vc
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    fileprivate func setupView() {
        view.backgroundColor = .white
        
        setupNavBar()
        
        setupPageMenu()
    }
    
    private func setupNavBar() {
        navigationItem.titleView = myRatingTitle
        navigationItem.rightBarButtonItem = editButtonItem
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        movieVC.isEditing = editing
    }
    
    private func setupPageMenu() {
        controllerArray.append(movieVC)
        
        var parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(0),
            .bottomMenuHairlineColor(UIColor.mainColor()),
            .scrollMenuBackgroundColor(UIColor.mainColor()),
            .viewBackgroundColor(UIColor.mainColor()),
            .selectionIndicatorColor(UIColor.userProfileTintColor()),
            .selectionIndicatorHeight(2),
            .menuHeight(40),
            .menuItemFont(UIFont(name: "Avenir-Medium", size: 14)!),
            .selectedMenuItemLabelColor(UIColor.userProfileTintColor()),
            .unselectedMenuItemLabelColor(.white),
            .useMenuLikeSegmentedControl(true)
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0,y: 0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        
        
        self.view.addSubview(pageMenu!.view)
    }
}












