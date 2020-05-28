//
//  SearchViewHeaderView.swift
//  MyMovies

import Foundation
import UIKit

protocol SearchViewHeaderViewDelegate {
    func searchViewHeaderViewDidClearAllSearch()
}

class SearchViewHeaderView: UITableViewHeaderFooterView {
    
    var delegate: SearchViewHeaderViewDelegate?
    
    lazy var clearButton: CustomButton = {
        let btn = CustomButton(type: .system)
        btn.setTitle("Clear all", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(handleClearAllSearch), for: .touchUpInside)
        btn.contentHorizontalAlignment = .right
        return btn
    }()
    
    lazy var recentSearch: CustomLabel = {
        let lbl = CustomLabel(frame: .zero, topInset: 0, bottomInset: 0, leftInset: 0, rightInset: 0)
        lbl.text = "Recent search:"
        lbl.font = UIFont(name: "Avenir-Heavy", size: 20)
        lbl.textColor = UIColor.tvShowCellTextColor()
        return lbl
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setupHeader()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHeader() {
        
        contentView.backgroundColor = UIColor.mainColor()
        
        contentView.addSubview(recentSearch)
        contentView.addSubview(clearButton)
        
        recentSearch.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 200, height: 50)
        clearButton.anchor(top: contentView.topAnchor, left: recentSearch.rightAnchor, bottom: nil, right: contentView.rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 10, width: 0, height: 50)
    }
    
    @objc private func handleClearAllSearch() {
        delegate?.searchViewHeaderViewDidClearAllSearch()
    }
}
