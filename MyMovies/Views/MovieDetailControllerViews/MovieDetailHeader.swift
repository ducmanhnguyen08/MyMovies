//
//  MovieDetailHeader.swift
//  MyMovies


import Foundation
import UIKit
import MBProgressHUD
import Cosmos
import Toast_Swift

public protocol MovieDetailHeaderDelegate {
    func movieDetailHeaderDidRateMovie(withRating rating: Double)
    func movieDetailHeaderDidClickWatchListButton(mediaId: Int, watchlist: Bool)
    func movieDetailHeaderDidClickFavouriteButton(mediaId: Int, favourite: Bool)
    func movieDetailHeaderIsInGuestMode()
}

class MovieDetailHeader: UICollectionViewCell {
    
    var isFirstTime = true
    
    var delegate: MovieDetailHeaderDelegate?
    
    var movie: Movie? {
        didSet {
            guard let movie = movie else { return }
            guard let runtime = movie.runtime else { return }
            guard let imageURL = URL(string: movie.poster_path) else { return }
            
            numberOfLikeLbl.text = String(movie.vote_count) + " likes"
            movieName.text = movie.title
            movieTypeLabel.text = movie.movieType! + " - \(runtime) minutes - \(movie.release_date)"
            posterImage.sd_setImage(with: imageURL, placeholderImage: #imageLiteral(resourceName: "frame-landscape"), options: .progressiveDownload, completed: nil)
            ratingLbl.attributedText = MovieDetailController.createAttributedTextForRating(firstString: "\(movie.vote_average)", secondString: "/10")
            userRatingStar.rating = (movie.rating ?? 0) / 2
            userRatingStar.text = String(movie.rating ?? 0)
            
            if movie.isFavourite ?? false {
                favouriteIcon.image = #imageLiteral(resourceName: "favourite_icon_selected")
            }
            
            if movie.isInWatchList ?? false {
                addToWatchList.image = #imageLiteral(resourceName: "checked_movie")
            }
            //Substring the year
            let index = movie.release_date.index(movie.release_date.startIndex, offsetBy: 4)
            let yearString = movie.release_date[..<index]
            
            
            movieYearOfRelease.attributedText = MovieDetailHeader.createAttributedText(firstString: "MOVIE ", secondString: "\(yearString)")
        }
    }
    
    private lazy var addToWatchList: UIImageView = {
        let ic = UIImageView()
        ic.image = #imageLiteral(resourceName: "add")
        ic.contentMode = .scaleAspectFit
        ic.clipsToBounds = true
        ic.isUserInteractionEnabled = true
        ic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAddToWatchListClicked)))
        return ic
    }()
    
    lazy var upperMovieHeaderContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var favouriteIcon: UIImageView = {
        let ic = UIImageView()
        ic.image = #imageLiteral(resourceName: "favourite_icon_unselected")
        ic.contentMode = .scaleAspectFill
        ic.clipsToBounds = true
        ic.isUserInteractionEnabled = true
        ic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFavouriteButtonClicked)))
        return ic
    }()
    
    lazy var userRatingStar: CosmosView = {
        let view = CosmosView()
        view.settings.updateOnTouch = true
        view.settings.fillMode = .half
        view.rating = 0
        view.text = "0.0"
        return view
    }()
    
    lazy var numberOfLikeLbl: UILabel = {
        let numberOfLike = UILabel()
        numberOfLike.textColor = UIColor.tvShowCellTextColor()
        numberOfLike.font = UIFont(name: "Avenir-Medium", size: 15)!
        return numberOfLike
    }()
    
    let likeLabel: UIImageView = {
        let lbl = UIImageView()
        lbl.image = #imageLiteral(resourceName: "thumbs-up-hand-symbol")
        lbl.contentMode = .scaleAspectFit
        lbl.clipsToBounds = true
        return lbl
    }()
    
    let ratingLbl: CustomLabel = {
        let lbl = CustomLabel(frame: .zero, topInset: 0, bottomInset: 0, leftInset: 0, rightInset: 0)
        lbl.layer.cornerRadius = 35
        lbl.layer.borderColor = UIColor.movieTintColor().cgColor
        lbl.layer.borderWidth = 2
        lbl.textAlignment = .center
        return lbl
    }()
    
    let movieInfoContainer: UIView = {
        let container = UIView()
        return container
    }()
    
    let divider: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.movieTintColor()
        return view
    }()
    
    let movieTypeLabel: CustomLabel = {
        let movieType = CustomLabel(frame: .zero, topInset: 0, bottomInset: 0, leftInset: 0, rightInset: 0)
        movieType.font = UIFont(name: "Avenir-Medium", size: 14)!
        movieType.textColor = .white
        movieType.numberOfLines = 0
        return movieType
    }()
    
    let movieName: CustomLabel = {
        let name = CustomLabel(frame: .zero, topInset: -8, bottomInset: 0, leftInset: 0, rightInset: 0)
        name.textColor = .white
        name.font = UIFont(name: "AvenirNext-Bold", size: 30)!
        name.numberOfLines = 0
        return name
    }()
    
    let movieYearOfRelease: UILabel = {
        let year = UILabel()
        return year
    }()
    
    let lowerDimbackground: UIView = {
        let bg = UIView()
        return bg
    }()
    
    let posterImage: UIImageView = {
        let poster = UIImageView()
        poster.image = #imageLiteral(resourceName: "frame-landscape")
        poster.contentMode = .scaleAspectFit
        poster.clipsToBounds = true
        return poster
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHeader()
        
    }
    
    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        
        if isFirstTime {
            lowerDimbackground.setGradientBackground(firstColor: .black, secondColor: .clear)
            upperMovieHeaderContainer.setGradientBackgroundForFavouriteIcon(firstColor: .black, secondColor: .clear)
            isFirstTime = !isFirstTime
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupHeader() {
        backgroundColor = .clear
        
        setupBackground()
    }
    
    fileprivate func setupBackground() {
        addSubview(posterImage)

        posterImage.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        setupMovieInfoContainer()
        
        setupMovieRating()
    }
    
    fileprivate func setupMovieRating() {
        posterImage.addSubview(ratingLbl)
        posterImage.addSubview(likeLabel)
        posterImage.addSubview(numberOfLikeLbl)
        addSubview(userRatingStar)
        
        ratingLbl.anchor(top: movieInfoContainer.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 15, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 70, height: 70)
        likeLabel.anchor(top: movieInfoContainer.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 25, height: 25)
        numberOfLikeLbl.anchor(top: movieInfoContainer.bottomAnchor, left: likeLabel.rightAnchor, bottom: nil, right: nil, paddingTop: 25, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 100, height: 25)
        userRatingStar.anchor(top: numberOfLikeLbl.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: ratingLbl.leftAnchor, paddingTop: 15, paddingLeft: 20, paddingBottom: 15, paddingRight: 0, width: 0, height: 0)
        
        // Rating a movie
        
        guard let currentUser = UserSessionController.shared.getCurrentUser() else { return }
        
        if currentUser.sessionType == .imbdUser {
            userRatingStar.isUserInteractionEnabled = true
        } else {
            userRatingStar.isUserInteractionEnabled = false
        }
        
        userRatingStar.didTouchCosmos = { rating in
            self.userRatingStar.text = String(rating * 2)
        }
        
        userRatingStar.didFinishTouchingCosmos = { rating in
            // Pass the rating to the movieDetailController via delegation
            self.delegate?.movieDetailHeaderDidRateMovie(withRating: rating * 2)
           
        }
    }
    
    fileprivate func setupMovieInfoContainer() {
        
        posterImage.addSubview(lowerDimbackground)
        
        posterImage.addSubview(upperMovieHeaderContainer)
        
        addSubview(favouriteIcon)
        
        addSubview(addToWatchList)
        
        lowerDimbackground.anchor(top: nil, left: posterImage.leftAnchor, bottom: posterImage.bottomAnchor, right: posterImage.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 300)
        
        upperMovieHeaderContainer.anchor(top: posterImage.topAnchor, left: posterImage.leftAnchor, bottom: lowerDimbackground.topAnchor, right: posterImage.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        favouriteIcon.anchor(top: upperMovieHeaderContainer.topAnchor, left: nil, bottom: nil, right: upperMovieHeaderContainer.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 30, height: 30)
        
        addToWatchList.anchor(top: upperMovieHeaderContainer.topAnchor, left: nil, bottom: nil, right: favouriteIcon.leftAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 10, width: 30, height: 30)
        
        lowerDimbackground.addSubview(movieInfoContainer)
        
        movieInfoContainer.anchor(top: lowerDimbackground.topAnchor, left: lowerDimbackground.leftAnchor, bottom: nil, right: lowerDimbackground.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 180)
        
        movieInfoContainer.addSubview(movieYearOfRelease)
        movieInfoContainer.addSubview(movieName)
        movieInfoContainer.addSubview(movieTypeLabel)
        movieInfoContainer.addSubview(divider)
        
        movieYearOfRelease.anchor(top: movieInfoContainer.topAnchor, left: movieInfoContainer.leftAnchor, bottom: nil, right: movieInfoContainer.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        movieName.anchor(top: movieYearOfRelease.bottomAnchor, left: movieInfoContainer.leftAnchor, bottom: nil, right: movieInfoContainer.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 75)
        movieTypeLabel.anchor(top: movieName.bottomAnchor, left: movieInfoContainer.leftAnchor, bottom: movieInfoContainer.bottomAnchor, right: movieInfoContainer.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        divider.anchor(top: nil, left: movieInfoContainer.leftAnchor, bottom: movieInfoContainer.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 20, height: 1)
    }
    
    // MARK: Handle icon click
    
    @objc private func handleFavouriteButtonClicked() {
        
        guard let currentUser = UserSessionController.shared.getCurrentUser() else { return }
        
        if currentUser.sessionType == .imbdUser {
            guard let movie = movie else { return }
            guard let isFavourite = movie.isFavourite else { return }
            
            delegate?.movieDetailHeaderDidClickFavouriteButton(mediaId: movie.id, favourite: !isFavourite)
            
            movie.isFavourite = !isFavourite
            
            // Check the state of favourite for movie then assign the corresponding image
            
            if movie.isFavourite ?? false {
                favouriteIcon.image = #imageLiteral(resourceName: "favourite_icon_selected")
            } else {
                favouriteIcon.image = #imageLiteral(resourceName: "favourite_icon_unselected")
            }
        } else {
            delegate?.movieDetailHeaderIsInGuestMode()
        }
    }
    
    @objc private func handleAddToWatchListClicked() {
        guard let currentUser = UserSessionController.shared.getCurrentUser() else { return }
        if currentUser.sessionType == .imbdUser {
            
            guard let movie = movie else { return }
            guard let isInWatchList = movie.isInWatchList else { return }
            
            delegate?.movieDetailHeaderDidClickWatchListButton(mediaId: movie.id, watchlist: !isInWatchList)
            
            movie.isInWatchList = !isInWatchList
            
            // Check the state of watchlist icon for movie then assign the corresponding image
            
            if movie.isInWatchList ?? false {
                addToWatchList.image = #imageLiteral(resourceName: "checked_movie")
            } else {
                addToWatchList.image = #imageLiteral(resourceName: "add")
            }
            
        } else {
            delegate?.movieDetailHeaderIsInGuestMode()
        }
        
    }
    
    fileprivate static func createAttributedText(firstString: String, secondString: String) -> NSAttributedString {
        
        let firstAttributedString = NSMutableAttributedString(string: firstString, attributes: [NSAttributedString.Key.font : UIFont(name: "Avenir-Heavy", size: 17)!, NSAttributedString.Key.foregroundColor : UIColor.movieTintColor()])
        firstAttributedString.append(NSMutableAttributedString(string: secondString, attributes: [NSAttributedString.Key.font : UIFont(name: "Avenir-Heavy", size: 17)!, NSAttributedString.Key.foregroundColor : UIColor.white]))
        
        return firstAttributedString
    }
    
    fileprivate static func createAttributedTextForRating(firstString: String, secondString: String) -> NSAttributedString {
        
        let firstAttributedString = NSMutableAttributedString(string: firstString, attributes: [NSAttributedString.Key.font : UIFont(name: "AvenirNext-Bold", size: 23)!, NSAttributedString.Key.foregroundColor : UIColor.movieTintColor()])
        firstAttributedString.append(NSMutableAttributedString(string: secondString, attributes: [NSAttributedString.Key.font : UIFont(name: "Avenir-Book", size: 12)!, NSAttributedString.Key.foregroundColor : UIColor.tvShowCellTextColor()]))
        
        return firstAttributedString
    }
    
}





