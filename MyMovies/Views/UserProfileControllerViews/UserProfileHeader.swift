//
//  UserProfileHeader.swift
//  MyMovies

import Foundation
import UIKit

class UserProfileHeader: UIView {
    
    var username: String? {
        didSet {
            guard let username = username else { return }
            usernameLbl.text = username
        }
    }
    
    let userProfileImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "cast_placeHolder")
        image.contentMode = .scaleAspectFill
        image.layer.borderWidth = 0.5
        image.layer.borderColor = UIColor.white.cgColor
        image.clipsToBounds = true
        image.layer.cornerRadius = 50
        return image
    }()
    
    let usernameLbl: CustomLabel = {
        let username = CustomLabel()
        username.text = ""
        username.font = UIFont(name: "Avenir-Black", size: 20)
        username.textColor = .white
        username.textAlignment = .center
        return username
    }()
    
    let backgroundImage: UIImageView = {
        let bg = UIImageView()
        bg.image = #imageLiteral(resourceName: "cast_placeHolder")
        bg.contentMode = .scaleAspectFill
        bg.clipsToBounds = true
        return bg
    }()
    
    let userProfileTintBackground: UIView = {
        let bg = UIView()
        bg.alpha = 0.9
        bg.backgroundColor = UIColor.userProfileTintColor()
        return bg
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHeader()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupHeader() {
        backgroundColor = .clear
        addSubview(backgroundImage)
        addSubview(userProfileTintBackground)
        addSubview(userProfileImage)
        addSubview(usernameLbl)
        
        backgroundImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        userProfileTintBackground.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        userProfileImage.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 50, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        userProfileImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        usernameLbl.anchor(top: userProfileImage.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 15, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 40)
    }
    
}






