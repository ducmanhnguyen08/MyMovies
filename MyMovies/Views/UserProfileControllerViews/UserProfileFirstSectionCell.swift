//
//  UserProfileFirstSectionCell.swift
//  MyMovies

import Foundation
import UIKit

class UserProfileFirstSectionCell: UITableViewCell {
    
    var cellModel: UserProfileCellModel? {
        didSet {
            guard let model = cellModel else { return }
            icon.image = model.icon
            textLbl.text = model.text
        }
    }
    
    let icon: UIImageView = {
        let ic = UIImageView()
        ic.image = #imageLiteral(resourceName: "star")
        ic.contentMode = .scaleAspectFit
        ic.clipsToBounds = true
        return ic
    }()
    
    let textLbl: CustomLabel = {
        let lbl = CustomLabel()
        lbl.text = "Favourites"
        lbl.font = UIFont(name: "Avenir-Medium", size: 15)
        lbl.textColor = .white
        lbl.textAlignment = .left
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        backgroundColor = .clear
        selectionStyle = .none
        accessoryType = .disclosureIndicator
        
        addSubview(icon)
        
        addSubview(textLbl)
        
        icon.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 30, height: 0)
        textLbl.anchor(top: topAnchor, left: icon.rightAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 200, height: 0)
        
    }
}
