//
//  MainTabBarController.swift
//  MyMovies

import UIKit

extension MainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
        guard let vc = viewController as? UINavigationController else { return }
        
        guard let tabBarViewControllers = tabBarController.viewControllers else { return }
        
        let index = tabBarViewControllers.firstIndex(of: vc) ?? -1
        
        switch index {
        case 0:
            tabBar.tintColor = UIColor.movieTintColor()
        case 1:
            tabBar.tintColor = UIColor.userProfileTintColor()
        default:
            tabBar.tintColor = UIColor.movieTintColor()
        }
    }
    
}

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewControllers()
        
        delegate = self
    }
    
    fileprivate func setupViewControllers() {
        let movieController = templateViewController(unselectedImage: #imageLiteral(resourceName: "movie"), title: "MOVIES", rootViewController: MovieContainerViewController())
        let userProfileController = templateViewController(unselectedImage: #imageLiteral(resourceName: "profile"), title: "PROFILE", rootViewController: UserProfileController())
        
        tabBar.tintColor = UIColor.movieTintColor()
        tabBar.isTranslucent = false
        tabBar.barTintColor = UIColor.mainColor()
        
        viewControllers = [movieController, userProfileController]
        
        guard let items = tabBar.items else { return }
        
        for item in items {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    private func templateViewController(unselectedImage: UIImage, title: String, rootViewController: UIViewController = UIViewController()) -> CustomNavigationController {
        let viewController = rootViewController
        let navController = CustomNavigationController(rootViewController: viewController)
        let font = UIFont(name: "Avenir-Heavy", size: 9)!
        navController.tabBarItem.image = unselectedImage
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font : font], for: .normal)
        navController.tabBarItem.title = title
        return navController
    }
    
}
