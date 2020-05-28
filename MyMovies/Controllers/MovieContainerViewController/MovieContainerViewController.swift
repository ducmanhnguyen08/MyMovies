//
//  MovieContainerViewController.swift
//  MyMovies


import Foundation
import UIKit
import PageMenu

extension MovieContainerViewController: PopularMovieViewControllerDelegate {
    func popularMovieViewController(viewController: UIViewController, didSelectMovieWithID id: Int) {
        let layout = UICollectionViewFlowLayout()
        let vc = MovieDetailController(collectionViewLayout: layout)
        vc.movieID = id
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MovieContainerViewController: NowPlayingMovieViewControllerDelegate {
    func nowPlayingMovieViewController(viewController: UIViewController, didSelectMovieWithID id: Int) {
        let layout = UICollectionViewFlowLayout()
        let vc = MovieDetailController(collectionViewLayout: layout)
        vc.movieID = id
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MovieContainerViewController: UpcomingMovieViewControllerDelegate {
    func upcomingMovieViewController(viewController: UIViewController, didSelectMovieWithID id: Int) {
        let layout = UICollectionViewFlowLayout()
        let vc = MovieDetailController(collectionViewLayout: layout)
        vc.movieID = id
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension MovieContainerViewController: TopRatedMovieViewControllerDelegate {
    func topRatedMovieViewController(viewController: UIViewController, didSelectMovieWithID id: Int) {
        let layout = UICollectionViewFlowLayout()
        let vc = MovieDetailController(collectionViewLayout: layout)
        vc.movieID = id
        navigationController?.pushViewController(vc, animated: true)
    }
}

class MovieContainerViewController: UIViewController {
    
    var pageMenu: CAPSPageMenu?
    var controllerArray : [UIViewController] = []
    
    let movieTitle: CustomLabel = {
        let label = CustomLabel(frame: .zero, topInset: 0, bottomInset: 0, leftInset: 0, rightInset: 0)
        label.addCharactersSpacing(spacing: 5, text: "MOVIES")
        label.font = UIFont(name: "Avenir-Heavy", size: 17)
        label.textColor = UIColor.movieTintColor()
        label.textAlignment = .center
        return label
    }()
    
    let upComingVC: UpcomingMovieViewController = {
        let layout = UICollectionViewFlowLayout()
        let vc = UpcomingMovieViewController(collectionViewLayout: layout)
        vc.title = "Up Coming"
        return vc
    }()
    
    let topRatedVC: TopRatedMovieViewController = {
        let topRatedLayout = UICollectionViewFlowLayout()
        let vc = TopRatedMovieViewController(collectionViewLayout: topRatedLayout)
        vc.title = "Top Rated"
        return vc
    }()
    
    let nowPlayingVC: NowPlayingMovieViewController = {
        let nowPlayingLayout = UICollectionViewFlowLayout()
        let vc = NowPlayingMovieViewController(collectionViewLayout: nowPlayingLayout)
        vc.title = "Now Playing"
        return vc
    }()
    
    let popularVC: PopularMovieViewController = {
        let popularVCLayout = UICollectionViewFlowLayout()
        let vc = PopularMovieViewController(collectionViewLayout: popularVCLayout)
        vc.title = "Popular"
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        restoreNavigationBar()
        
        super.viewWillAppear(animated)
        
    }
    
    fileprivate func setupViews() {
        view.backgroundColor = UIColor.mainColor()
        
        setupPageMenu()
        
        setupNavigationBar()
    }
    
    fileprivate func restoreNavigationBar() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = UIColor.mainColor()
    }
    
    fileprivate func setupNavigationBar() {
        navigationController?.navigationBar.shadowImage = UIImage()
        let backItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        navigationItem.backBarButtonItem = backItem
        navigationItem.titleView = movieTitle
    }
    
    fileprivate func setupPageMenu() {
        
        upComingVC.delegate = self
        topRatedVC.delegate = self
        nowPlayingVC.delegate = self
        popularVC.delegate = self
        
        controllerArray.append(upComingVC)
        controllerArray.append(topRatedVC)
        controllerArray.append(nowPlayingVC)
        controllerArray.append(popularVC)
       
        var parameters: [CAPSPageMenuOption] = [
            .menuItemSeparatorWidth(2),
            .bottomMenuHairlineColor(UIColor.mainColor()),
            .scrollMenuBackgroundColor(UIColor.mainColor()),
            .viewBackgroundColor(UIColor.mainColor()),
            .selectionIndicatorColor(UIColor.movieTintColor()),
            .selectionIndicatorHeight(2),
            .menuHeight(40),
            .menuItemFont(UIFont(name: "Avenir-Medium", size: 14)!),
            .selectedMenuItemLabelColor(UIColor.movieTintColor()),
            .unselectedMenuItemLabelColor(.white)
        ]
        
        pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRect(x: 0.0,y: 0, width: self.view.frame.width, height: self.view.frame.height), pageMenuOptions: parameters)
        
        
        self.view.addSubview(pageMenu!.view)
    }
}








