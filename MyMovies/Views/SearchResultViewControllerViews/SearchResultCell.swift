//
//  SearchResultCell.swift
//  MyMovies


import Foundation
import UIKit
import SDWebImage

class SearchResultCell: UITableViewCell {
    
    var recentSearch: RecentSearchObjectRealm? {
        didSet{
            guard let recentSearch = recentSearch else { return }
            guard let url = URL(string: recentSearch.posterPath) else { return }
            posterPathImage.sd_setImage(with: url, placeholderImage: nil, options: .highPriority, completed: nil)
            name.text = recentSearch.name
            numberOfVotes.text = String(recentSearch.voteCount) + " votes"
        }
    }
    
    var movie: Movie? {
        didSet {
            guard let movie = movie else { return }
            guard let url = URL(string: movie.poster_path) else { return }
            posterPathImage.sd_setImage(with: url, placeholderImage: nil, options: .highPriority, completed: nil)
            name.text = movie.title
            numberOfVotes.text = String(movie.vote_count) + " votes"
        }
    }
    
    let posterPathImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "poster_image")
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.white.cgColor
        return image
    }()
    
    let name: CustomLabel = {
        let label = CustomLabel(frame: .zero, topInset: 0, bottomInset: -15, leftInset: 0, rightInset: 0)
        label.text = "The shawshank Redemption"
        label.textColor = .white
        label.font = UIFont(name: "Avenir-Heavy", size: 17)
        return label
    }()
    
    let numberOfVotes: CustomLabel = {
        let vote = CustomLabel(frame: .zero, topInset: -25, bottomInset: 0, leftInset: 0, rightInset: 0)
        vote.text = "1234 votes"
        vote.font = UIFont(name: "Avenir-Medium", size: 13)
        vote.textColor = .white
        return vote
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
        
        selectionStyle = .none
        
        addSubview(posterPathImage)
        addSubview(name)
        addSubview(numberOfVotes)
        
        posterPathImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 5, paddingRight: 0, width: 90 / 1.6 , height: self.frame.height)
        name.anchor(top: topAnchor, left: posterPathImage.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: 0, height: 40)
        numberOfVotes.anchor(top: name.bottomAnchor, left: posterPathImage.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
}
