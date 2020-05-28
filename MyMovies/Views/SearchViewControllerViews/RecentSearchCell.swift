//
//  RecentSearchCell.swift
//  MyMovies


import Foundation
import UIKit

class RecentSearchCell: UITableViewCell {
    
    let searchIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = #imageLiteral(resourceName: "recent_search")
        icon.contentMode = .scaleAspectFit
        icon.clipsToBounds = true
        return icon
    }()
    
    let searchText: CustomLabel = {
        let lbl = CustomLabel(frame: .zero, topInset: 0, bottomInset: 0, leftInset: 0, rightInset: 0)
        lbl.text = "The shawshan redemption"
        lbl.font = UIFont(name: "Avenir-Book", size: 15)
        lbl.textColor = UIColor.white
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupCell() {
        
        backgroundColor = UIColor.mainColor()
        
        self.selectionStyle = .none
        
        addSubview(searchIcon)
        addSubview(searchText)
        
        searchIcon.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 0, width: self.frame.height, height: 0)
        
        searchText.anchor(top: topAnchor, left: searchIcon.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
}
