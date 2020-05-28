//
//  CustomNavigationController.swift
//  MyMovies


import Foundation
import UIKit

class CustomNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = UIColor.mainColor()
        self.navigationBar.tintColor = UIColor.white
        self.navigationBar.isTranslucent = false
        self.definesPresentationContext = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
}
