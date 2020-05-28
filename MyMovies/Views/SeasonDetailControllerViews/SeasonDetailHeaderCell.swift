//
//  SeasonDetailHeaderCell.swift
//  MyMovies

import Foundation
import UIKit
import SDWebImage

class SeasonDetailHeaderCell: UICollectionViewCell {
    
    var season: Season? {
        didSet {
            guard let season = season else { return }
            guard let url = URL(string: season.poster_path) else { return }
            seasonLabel.text = "\(season.name.uppercased()) - \(season.episodes?.count ?? 0) episodes"
            seasonName.text = season.name
            seasonAirDateLabel.text = "Season aired on \(season.air_date)"
            posterImage.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "frame-landscape"), options: .highPriority, progress: nil, completed: nil)
        }
    }
    
    let seasonAirDateLabel: CustomLabel = {
        let seasonAirDate = CustomLabel(frame: .zero, topInset: 0, bottomInset: 0, leftInset: 0, rightInset: 0)
        seasonAirDate.font = UIFont(name: "Avenir-Medium", size: 14)!
        seasonAirDate.textColor = .white
        seasonAirDate.text = "Season aired on 1989-12-17"
        seasonAirDate.numberOfLines = 0
        return seasonAirDate
    }()
    
    let seasonName: CustomLabel = {
        let name = CustomLabel(frame: .zero, topInset: -8, bottomInset: 0, leftInset: 0, rightInset: 0)
        name.textColor = .white
        name.font = UIFont(name: "AvenirNext-Bold", size: 30)!
        name.text = "The ShimShon and 7 Kids"
        name.numberOfLines = 0
        return name
    }()
    
    let seasonLabel: CustomLabel = {
        let lbl = CustomLabel(frame: .zero, topInset: 0, bottomInset: 0, leftInset: 0, rightInset: 0)
        lbl.text = "Season 1 - 26 episodes".uppercased()
        lbl.textColor = UIColor.tvShowTintColor()
        lbl.textAlignment = .left
        lbl.font = UIFont(name: "Avenir-Heavy", size: 14)!
        return lbl
    }()
    
    let dimbackground: UIView = {
        let bg = UIView()
        bg.backgroundColor = .black
        return bg
    }()
    
    let posterImage: UIImageView = {
        let poster = UIImageView()
        poster.contentMode = .scaleAspectFill
        poster.clipsToBounds = true
        return poster
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHeader()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupHeader() {
        addSubview(posterImage)
        posterImage.addSubview(dimbackground)
        dimbackground.addSubview(seasonLabel)
        dimbackground.addSubview(seasonName)
        dimbackground.addSubview(seasonAirDateLabel)
        
        posterImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        dimbackground.anchor(top: nil, left: posterImage.leftAnchor, bottom: posterImage.bottomAnchor, right: posterImage.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
        
        seasonLabel.anchor(top: dimbackground.topAnchor, left: dimbackground.leftAnchor, bottom: nil, right: dimbackground.rightAnchor, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 10, width: 0, height: 50)
        seasonName.anchor(top: seasonLabel.bottomAnchor, left: dimbackground.leftAnchor, bottom: nil, right: dimbackground.rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 10, width: 0, height: 50)
        seasonAirDateLabel.anchor(top: seasonName.bottomAnchor, left: dimbackground.leftAnchor, bottom: dimbackground.bottomAnchor, right: dimbackground.rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 5, paddingRight: 10, width: 0, height: 0)
    }
    
}
