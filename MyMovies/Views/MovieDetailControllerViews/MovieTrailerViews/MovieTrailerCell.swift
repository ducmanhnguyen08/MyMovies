//
//  MovieTrailerCell.swift
//  MyMovies


import Foundation
import UIKit
import SDWebImage

class MovieTrailerCell: UICollectionViewCell {
    
    var isFirstDimLayer: Bool = true
    
    var video: Video? {
        didSet {
            guard let video = video else { return }
            guard let url = URL(string: video.thumnailUrl) else { return }
            videoThumbnail.sd_setImage(with: url, completed: nil)
            trailerName.text = video.name
        }
    }
    
    let playIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = #imageLiteral(resourceName: "playBtn")
        icon.contentMode = .scaleAspectFit
        icon.clipsToBounds = true
        return icon
    }()
    
    let trailerNameBackground: UIView = {
        let bg = UIView()
        bg.backgroundColor = UIColor.trailerNameBackgroundColor()
        return bg
    }()
    
    let trailerName: UILabel = {
        let name = UILabel()
        name.text = "Good to Be King"
        name.textColor = UIColor.trailerNameColor()
        name.font = UIFont(name: "Avenir-Medium", size: 15)!
        return name
    }()
    
    let trailerDimBackGround: UIView = {
        let container = UIView()
        return container
    }()
    
    let videoThumbnail: UIImageView = {
        let thumbnail = UIImageView()
        thumbnail.image = #imageLiteral(resourceName: "back_drop_image")
        thumbnail.contentMode = .scaleAspectFill
        thumbnail.clipsToBounds = true
        return thumbnail
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isFirstDimLayer {
            trailerDimBackGround.setGradientBackgroundForTrailer(firstColor: UIColor(white: 0, alpha: 0.7), secondColor: .clear)
            isFirstDimLayer = false
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        
        addSubview(videoThumbnail)
        addSubview(trailerDimBackGround)
        addSubview(trailerNameBackground)
        trailerNameBackground.addSubview(trailerName)
        addSubview(playIcon)
        
        videoThumbnail.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        trailerDimBackGround.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        trailerNameBackground.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        trailerName.anchor(top: trailerNameBackground.topAnchor, left: trailerNameBackground.leftAnchor, bottom: trailerNameBackground.bottomAnchor, right: trailerNameBackground.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        playIcon.anchor(top: nil, left: nil, bottom: trailerNameBackground.topAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 50, paddingRight: 0, width: 35, height: 35)
        playIcon.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
}




