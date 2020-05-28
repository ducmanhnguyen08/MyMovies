//
//  RecommendationCell.swift
//  MyMovies


import Foundation
import UIKit
import SDWebImage

class RecommendationCell: UICollectionViewCell {
    
    var movie: Movie? {
        didSet {
            guard let movie = movie else { return }
            guard let url = URL(string: movie.poster_path) else { return }
            
            posterImage.sd_setImage(with: url, completed: nil)
        }
    }
    
    let posterImage: UIImageView = {
        let poster = UIImageView()
        poster.image = #imageLiteral(resourceName: "poster_image")
        poster.contentMode = .scaleAspectFill
        poster.clipsToBounds = true
        return poster
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        
        addSubview(posterImage)
        
        posterImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
}



