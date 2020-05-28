//
//  PopUpOptionCell.swift
//  MyMovies


import Foundation
import UIKit

class PopUpOptionCell: UICollectionViewCell {
    
    var option: PopUpOption? {
        didSet {
            iconImage.image = option?.iconImage
            optionTextLbl.text = option?.optionText.uppercased()
        }
    }
    
    lazy var iconImage: UIImageView = {
        let icon = UIImageView()
        icon.image = #imageLiteral(resourceName: "heart")
        icon.contentMode = .scaleAspectFit
        icon.clipsToBounds = true
        return icon
    }()
    
    lazy var optionTextLbl: CustomLabel = {
        let lbl = CustomLabel(frame: .zero, topInset: 0, bottomInset: 0, leftInset: 0, rightInset: 0)
        lbl.text = "Add to watchlist".uppercased()
        lbl.font = UIFont(name: "Avenir-Heavy", size: 15)!
        lbl.textColor = .white
        lbl.textAlignment = .left
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        backgroundColor = UIColor.lowerViewBgColor()
        
        addSubview(iconImage)
        addSubview(optionTextLbl)
        
        iconImage.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 35, height: 35)
        iconImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        optionTextLbl.anchor(top: topAnchor, left: iconImage.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        
    }
    
}





