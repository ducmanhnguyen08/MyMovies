//
//  UserProfileSecondSectionCell.swift
//  MyMovies

import Foundation
import UIKit

class UserProfileSecondSectionCell: UITableViewCell {
    
    let textLbl: CustomLabel = {
        let lbl = CustomLabel()
        lbl.text = "About the app"
        lbl.font = UIFont(name: "Avenir-Medium", size: 15)
        lbl.textAlignment = .center
        lbl.textColor = .white
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
        
        addSubview(textLbl)
        
        textLbl.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
}
