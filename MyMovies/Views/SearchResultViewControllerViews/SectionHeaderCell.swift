//
//  SectionHeaderCell.swift
//  MyMovies
import Foundation
import UIKit

class SectionHeaderCell: UITableViewCell {
    
    let sectionName: CustomLabel = {
        let lbl = CustomLabel()
        lbl.text = "Movie"
        lbl.font = UIFont(name: "Avenir-Heavy", size: 13)
        lbl.textColor = .white
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupHeader()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupHeader() {
        backgroundColor = UIColor(white: 1, alpha: 0.3)
        
        addSubview(sectionName)
        
        sectionName.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
}
