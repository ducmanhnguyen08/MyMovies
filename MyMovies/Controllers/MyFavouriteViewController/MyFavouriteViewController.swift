//
//  MyFavouriteVireController.swift
//  MyMovies


import Foundation
import UIKit
import PageMenu
import MBProgressHUD

extension MyFavouriteViewController: MyMoviesFavouriteViewControllerDelegate {
    func myMoviesFavouriteViewControllerDelegate(viewController: UIViewController, didSelectMovie movie: Movie) {
        let layout = UICollectionViewFlowLayout()
        let vc = MovieDetailController(collectionViewLayout: layout)
        vc.movieID = movie.id
        let navVC = CustomNavigationController(rootViewController: vc)
        
        self.present(navVC, animated: true)
    }
}

class MyFavouriteViewController: UIViewController {
    
    var pageMenu: CAPSPageMenu?
    var controllerArray : [UIViewController] = []
    
    lazy var myRatingTitle: CustomLabel = {
        let label = CustomLabel(frame: .zero, topInset: 0, bottomInset: 0, leftInset: 0, rightInset: 0)
        label.addCharactersSpacing(spacing: 5, text: "FAVOURITES")
        label.font = UIFont(name: "Avenir-Heavy", size: 17)
        label.textColor = UIColor.userProfileTintColor()
        label.textAlignment = .center
        return label
    }()
    
    lazy var movieVC: MyMovieFavouriteViewController = {
        let layout = UICollectionViewFlowLayout()
        let vc = MyMovieFavouriteViewController(collectionViewLayout: layout)
        vc.title = "Movies"
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Constant.shouldReloadFavouriteMovie {
            
            movieVC.getListOfRatingMovies(completionHandler: {
                MBProgressHUD.hide(for: self.movieVC.collectionView!, animated: true)
            })
            Constant.shouldReloadFavouriteMovie = false
            
        }
    }
    
    fileprivate func setupView() {
        view.backgroundColor = .white
        
        setupNavBar()
        
        setupPageMenu()
    }
    
    private func setupNavBar() {
        navigationItem.titleView = myRatingTitle
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    private func setupPageMenu() {
        controllerArray.append(movieVC)
        
        movieVC.delegate = self
        
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
