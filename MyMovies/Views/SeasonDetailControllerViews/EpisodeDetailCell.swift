//
//  EpisodeDetailCell.swift
//  MyMovies


import Foundation
import UIKit
import SDWebImage

class EpisodeDetailCell: UICollectionViewCell {
    
    var indexOfCell: Int? {
        didSet {
            guard let index = indexOfCell else { return }
            if (index % 2) == 0 {
                backgroundColor = UIColor.tvShowEvenCellBackgroundColor()
            } else {
                backgroundColor = UIColor.tvShowOddCellBackgroundColor()
            }
        }
    }
    
    var episode: Episode? {
        didSet {
            guard let episode = episode else { return }
            
            episodeAirDate.text = episode.air_date
            
            episodeLbl.attributedText = EpisodeDetailCell.createAttributedText(firstString: "EP \(episode.episode_number) - ", secondString: "\(episode.name.uppercased())")
            
            guard let url = URL(string: episode.still_path) else { return }
            backdropImage.sd_setImage(with: url, placeholderImage: nil, options: .progressiveDownload, progress: nil, completed: nil)
        }
    }
    
    let episodeAirDate: CustomLabel = {
        let lbl = CustomLabel(frame: .zero, topInset: -15, bottomInset: 0, leftInset: 0, rightInset: 0)
        lbl.text = "1989-32-32"
        lbl.textColor = UIColor.white
        lbl.font = UIFont(name: "Avenir-Medium", size: 13)!
        return lbl
    }()
    
    let episodeLbl: CustomLabel = {
        let lbl = CustomLabel(frame: .zero, topInset: 0, bottomInset: -15, leftInset: 0, rightInset: 0)
        lbl.numberOfLines = 0
        lbl.attributedText = createAttributedText(firstString: "EP 1 ", secondString: "Season 1".uppercased())
        return lbl
    }()
    
    let backdropImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.image = #imageLiteral(resourceName: "frame-landscape")
        image.clipsToBounds = true
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        addSubview(backdropImage)
        addSubview(episodeLbl)
        addSubview(episodeAirDate)
        
        backdropImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: self.frame.height * 1.6, height: 0)
        episodeLbl.anchor(top: topAnchor, left: backdropImage.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 10, width: 0, height: 50)
        episodeAirDate.anchor(top: episodeLbl.bottomAnchor, left: backdropImage.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 10, paddingRight: 10, width: 0, height: 0)
    }
    
    fileprivate static func createAttributedText(firstString: String, secondString: String) -> NSAttributedString {
        
        let firstAttributedString = NSMutableAttributedString(string: firstString, attributes: [NSAttributedString.Key.font : UIFont(name: "Avenir-Medium", size: 13)!, NSAttributedString.Key.foregroundColor : UIColor.tvShowCellTextColor()])
        firstAttributedString.append(NSMutableAttributedString(string: secondString, attributes: [NSAttributedString.Key.font : UIFont(name: "Avenir-Heavy", size: 13)!, NSAttributedString.Key.foregroundColor : UIColor.white]))
        
        return firstAttributedString
    }
}






