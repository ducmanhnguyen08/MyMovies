//
//  MovieDetailOverViewCell.swift
//  MyMovies

import Foundation
import UIKit

class MovieDetailOverViewCell: UICollectionViewCell {
    
    var overView: String? {
        didSet {
            guard let overview = overView else { return }
            overViewText.text = overview
        }
    }
    
    let containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    let overViewLbl: UILabel = {
        let lbl = UILabel()
        lbl.text = "Overview:"
        lbl.font = UIFont(name: "Avenir-Heavy", size: 15)!
        lbl.textColor = .black
        return lbl
    }()
    
    let overViewText: UITextView = {
        let tv = UITextView()
        tv.text = ""
        tv.textColor = UIColor.tvShowCellTextColor()
        tv.font = UIFont(name: "Avenir-Medium", size: 12)!
        tv.isUserInteractionEnabled = false
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        backgroundColor = .white
        
        contentView.addSubview(containerView)
        
        containerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        containerView.addSubview(overViewLbl)
        containerView.addSubview(overViewText)
        
        overViewLbl.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 100, height: 30)
        overViewText.anchor(top: overViewLbl.bottomAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 8, paddingRight: 10, width: 0, height: 0)
    }
}




