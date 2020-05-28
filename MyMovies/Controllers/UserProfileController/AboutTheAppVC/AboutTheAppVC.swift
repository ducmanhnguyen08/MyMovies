//
//  AboutTheAppVC.swift
//  MyMovies
//


import Foundation
import UIKit

class AboutTheAppVC: UIViewController {
    
    lazy var versionLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Version 1.0.0"
        lbl.textColor = .white
        lbl.font = UIFont(name: "Avenir-Heavy", size: 12)
        lbl.textAlignment = .center
        return lbl
    }()
    
    lazy var iconLogo: UIImageView = {
        let logo = UIImageView()
        logo.contentMode = .scaleAspectFill
        logo.clipsToBounds = true
        logo.image = #imageLiteral(resourceName: "Icon-83.5")
        logo.layer.borderWidth = 1
        logo.layer.borderColor = UIColor.white.cgColor
        logo.layer.cornerRadius = 50
        return logo
    }()
    
    lazy var aboutLbl: CustomLabel = {
        let text = CustomLabel(frame: .zero, topInset: 0, bottomInset: 0, leftInset: 2, rightInset: 2)
        text.backgroundColor = .darkGray
        text.textColor = .white
        text.textAlignment = .justified
        text.numberOfLines = 0
        text.font = UIFont(name: "Avenir-Heavy", size: 15)
        text.text = "App for movies lovers."
        return text
    }()
    
    lazy var aboutTitle: CustomLabel = {
        let label = CustomLabel(frame: .zero, topInset: 0, bottomInset: 0, leftInset: 0, rightInset: 0)
        label.addCharactersSpacing(spacing: 5, text: "ABOUT")
        label.font = UIFont(name: "Avenir-Heavy", size: 17)
        label.textColor = UIColor.userProfileTintColor()
        label.textAlignment = .center
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    // Set up methods
    
    private func setupViews() {
        view.backgroundColor = UIColor.mainColor()
        view.addSubview(aboutLbl)
        view.addSubview(iconLogo)
        view.addSubview(versionLbl)
        
        aboutLbl.anchor(top: view.centerYAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: -50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 180)
        iconLogo.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        iconLogo.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        versionLbl.anchor(top: iconLogo.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 30)
        
        setupNavBar()
    }
    
    private func setupNavBar() {
        navigationItem.titleView = aboutTitle
    }
}
