//
//  CrewCell.swift
//  MyMovies


import Foundation
import UIKit
import SDWebImage

class CastCell: UICollectionViewCell {
    
    var cast: Cast? {
        didSet {
            guard let cast = cast else { return }
            guard let url = URL(string: cast.profile_path) else { return }
            crewNameLbl.text = cast.name
            crewProfile.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "cast_placeHolder"), options: .highPriority, completed: nil)
        }
    }
    
    let crewNameLbl: UILabel = {
        let name = UILabel()
        name.text = "Chadwick Boseman"
        name.textColor = UIColor.trailerNameColor()
        name.font = UIFont(name: "Avenir-Medium", size: 15)!
        name.textAlignment = .center
        return name
    }()
    
    let crewProfile: UIImageView = {
        let crew = UIImageView()
        crew.image = #imageLiteral(resourceName: "profile_image")
        crew.layer.cornerRadius = 50
        crew.contentMode = .scaleAspectFill
        crew.clipsToBounds = true
        crew.layer.borderWidth = 1
        crew.layer.borderColor = UIColor.white.cgColor
        return crew
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        addSubview(crewProfile)
        addSubview(crewNameLbl)
        
        crewProfile.anchor(top: topAnchor, left: nil, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        
        crewProfile.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        crewNameLbl.anchor(top: crewProfile.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 5, width: 0, height: 0)
    }
}






