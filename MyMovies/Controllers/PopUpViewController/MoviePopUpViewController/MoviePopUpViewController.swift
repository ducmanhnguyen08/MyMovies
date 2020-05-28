//
//  MoviePopUpViewController.swift
//  MyMovies


import Foundation
import UIKit
import SDWebImage
import XCDYouTubeKit
import AVKit
import Toast_Swift

enum MoviePopUpOption: Int {
    case addToWatchList = 0
    case playLastTrailer = 1
    case showAllDetail = 2
}

extension MoviePopUpViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor : nil
    }
}

extension MoviePopUpViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: lowerContainerView.frame.width, height: lowerContainerView.frame.height / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
}

class MoviePopUpViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let evrment = Environment(name: "Test", host: Constant.MOVIE_HOSTNAME)
    let interactor = Interactor()
    
    var movie: Movie? {
        didSet {
            guard let movie = movie else { return }
            guard let imageURL = URL(string: movie.poster_path) else { return }
            posterImage.sd_setImage(with: imageURL, completed: nil)
            movieTitle.text = movie.title
            ratingLbl.attributedText = MoviePopUpViewController.createAttributedText(firstString: "\(movie.vote_average)", secondString: "/10")
            movieDescriptionLbl.text = "Release date: \(movie.release_date)"
            
            let getAccountState = GetAccountStateWithMovie(id: String(movie.id))
            
            let dispatcher = NetworkingDispatcher(environment: evrment)
            
            getAccountState.execute(in: dispatcher, completionHandler: { (userState) in
                self.userState = userState
                
            }) { (errorCode) in
                print(errorCode)
            }
        }
    }
    
    var userState: MovieUserState? {
        didSet {
            movie?.rating = userState?.rating ?? 0
            movie?.isFavourite = userState?.isFavourite
            movie?.isInWatchList = userState?.isWatchList
            
            options.remove(at: 0)
            
            if movie?.isInWatchList ?? false {
                let removeFromWatchListOption = PopUpOption(iconImage: #imageLiteral(resourceName: "checked_movie"), optionText: "Remove from watchlist")
                options.insert(removeFromWatchListOption, at: 0)
            } else {
                let addToWatchListOption = PopUpOption(iconImage: #imageLiteral(resourceName: "add"), optionText: "Add to watchList")
                options.insert(addToWatchListOption, at: 0)
            }
            
            self.collectionView.reloadData()
        }
    }
    
    let upperContainerHeight: CGFloat = 220
    let cellID = "cellID"
    var options = [PopUpOption]()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.layer.cornerRadius = 15
        return view
    }()
    
    let upperContainerView: UIView = {
        let container = UIView()
        return container
    }()
    
    let lowerContainerView: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.lowerViewBgColor()
        container.layer.cornerRadius = 15
        return container
    }()
    
    let ratingLbl: CustomLabel = {
        let lbl = CustomLabel(frame: .zero, topInset: 0, bottomInset: 0, leftInset: 0, rightInset: 0)
        lbl.attributedText = createAttributedText(firstString: "8.4", secondString: "/10")
        lbl.layer.cornerRadius = 35
        lbl.layer.borderColor = UIColor.movieTintColor().cgColor
        lbl.layer.borderWidth = 2
        lbl.textAlignment = .center
        return lbl
    }()
    
    let posterImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "poster_image")
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    let movieTitle: CustomLabel = {
        let title = CustomLabel(frame: .zero, topInset: -18, bottomInset: 0, leftInset: 0, rightInset: 0)
        title.text = "What happen on Monday".uppercased()
        title.font = UIFont(name: "AvenirNext-Bold", size: 23)!
        title.numberOfLines = 0
        title.textColor = .white
        return title
    }()
    
    let movieDescriptionLbl: CustomLabel = {
        let label = CustomLabel(frame: .zero, topInset: -20, bottomInset: 0, leftInset: 0, rightInset: 0)
        label.text = "Action, Adventure, Science \n 2h - 14 May 2015"
        label.textColor = .white
        label.numberOfLines = 0
        label.font = UIFont(name: "AvenirNext-Medium", size: 13)!
        return label
    }()
    
    let blurVisualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        return blurEffectView
    }()
    
    let vibrancyVisualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        let vibrancyEffectView = UIVisualEffectView(effect: vibrancyEffect)
        return vibrancyEffectView
    }()
    
    lazy var closeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Close", for: .normal)
        btn.setTitleColor(UIColor.movieTintColor(), for: .normal)
        btn.addTarget(self, action: #selector(handleClosePopUp), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        
        setupPopUpOption()
        
        setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    fileprivate func setupViews() {
        view.addSubview(blurVisualEffectView)
        blurVisualEffectView.contentView.addSubview(vibrancyVisualEffectView)
        view.addSubview(closeBtn)
        view.addSubview(upperContainerView)
        
        blurVisualEffectView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        vibrancyVisualEffectView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        setupUpperViews()
        
        setupLowerViews()
        
    }
    
    fileprivate func setupPopUpOption() {
        let addToWatchListOption = PopUpOption(iconImage: #imageLiteral(resourceName: "add"), optionText: "Add to watchList")
        let playLastTrailerOption = PopUpOption(iconImage: #imageLiteral(resourceName: "playBtn"), optionText: "Play last trailer")
        let showDetailsOption = PopUpOption(iconImage: #imageLiteral(resourceName: "details"), optionText: "Show all details")
        
        options.append(addToWatchListOption)
        options.append(playLastTrailerOption)
        options.append(showDetailsOption)
    }
    
    @objc fileprivate func handleClosePopUp() {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate static func createAttributedText(firstString: String, secondString: String) -> NSAttributedString {
        
        let firstAttributedString = NSMutableAttributedString(string: firstString, attributes: [NSAttributedString.Key.font : UIFont(name: "AvenirNext-Bold", size: 23)!, NSAttributedString.Key.foregroundColor : UIColor.movieTintColor()])
        firstAttributedString.append(NSMutableAttributedString(string: secondString, attributes: [NSAttributedString.Key.font : UIFont(name: "Avenir-Book", size: 12)!, NSAttributedString.Key.foregroundColor : UIColor.tvShowCellTextColor()]))
        
        return firstAttributedString
    }
    
    fileprivate func setupUpperViews() {
        upperContainerView.anchor(top: nil, left: view.leftAnchor, bottom: view.centerYAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: upperContainerHeight)
        upperContainerView.addSubview(posterImage)
        posterImage.anchor(top: upperContainerView.topAnchor, left: upperContainerView.leftAnchor, bottom: upperContainerView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: upperContainerHeight / 1.66 , height: 0)
        upperContainerView.addSubview(movieTitle)
        movieTitle.anchor(top: upperContainerView.topAnchor, left: posterImage.rightAnchor, bottom: nil, right: upperContainerView.rightAnchor, paddingTop: 8, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: upperContainerHeight / 3)
        upperContainerView.addSubview(movieDescriptionLbl)
        movieDescriptionLbl.anchor(top: movieTitle.bottomAnchor, left: posterImage.rightAnchor, bottom: nil, right: upperContainerView.rightAnchor, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 60)
        upperContainerView.addSubview(ratingLbl)
        ratingLbl.anchor(top: movieDescriptionLbl.bottomAnchor, left: posterImage.rightAnchor, bottom: upperContainerView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 70, height: 70)
    }
    
    fileprivate func setupLowerViews() {
        view.addSubview(lowerContainerView)
        
        setupCollectionView()
        
        lowerContainerView.anchor(top: view.centerYAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 15, paddingBottom: 0, paddingRight: 15, width: 0, height: 210)
        lowerContainerView.addSubview(collectionView)
        collectionView.anchor(top: lowerContainerView.topAnchor, left: lowerContainerView.leftAnchor, bottom: lowerContainerView.bottomAnchor, right: lowerContainerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        closeBtn.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 50, paddingRight: 0, width: 0, height: 25)
        closeBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    fileprivate func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.optionCellDividerColor()
        collectionView.bounces = false
        collectionView.register(PopUpOptionCell.self, forCellWithReuseIdentifier: cellID)
    }
    
    func playVideo(videoIdentifier: String?) {
        let playerViewController = AVPlayerViewController()
        self.present(playerViewController, animated: true, completion: nil)
        
        XCDYouTubeClient.default().getVideoWithIdentifier(videoIdentifier) { [weak playerViewController] (video: XCDYouTubeVideo?, error: Error?) in
            if let streamURLs = video?.streamURLs, let streamURL = (streamURLs[XCDYouTubeVideoQualityHTTPLiveStreaming] ?? streamURLs[YouTubeVideoQuality.hd720] ?? streamURLs[YouTubeVideoQuality.medium360] ?? streamURLs[YouTubeVideoQuality.small240]) {
                playerViewController?.player = AVPlayer(url: streamURL)
                playerViewController?.player?.play()
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //MARK: CollectionView's config
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PopUpOptionCell
        cell.option = options[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return options.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let movie = movie else { return }
        
        var style = ToastStyle()
        
        style.backgroundColor = .black
        
        style.messageNumberOfLines = 1
        
        style.titleAlignment = .center
        
        let center = self.view.center
        
        switch indexPath.item {
        case MoviePopUpOption.addToWatchList.rawValue:
            
            guard let currentUser = UserSessionController.shared.getCurrentUser() else { return }
            
            if currentUser.sessionType == .imbdUser {
                let cell = self.collectionView.cellForItem(at: IndexPath(item: 0, section: 0)) as? PopUpOptionCell
                
                if movie.isInWatchList ?? false {
                    // Handle remove movie from watchlist
                    cell?.iconImage.image = #imageLiteral(resourceName: "add")
                    cell?.optionTextLbl.text = "Add to watchlist".uppercased()
                    movie.isInWatchList = false
                } else {
                    // Handle add movie to watchlist
                    cell?.iconImage.image = #imageLiteral(resourceName: "checked_movie")
                    cell?.optionTextLbl.text = "Remove from watchlist".uppercased()
                    movie.isInWatchList = true
                }
                
                
                let userEnvironment = Environment(name: "Test", host: Constant.ACCOUNT_HOSTNAME)
                let dispatcher = NetworkingDispatcher(environment: userEnvironment)
                let addToWatchListService = AddMediaToWatchListService(mediaType: "movie", mediaID: movie.id, watchList: movie.isInWatchList ?? false)
                
                addToWatchListService.execute(in: dispatcher, completionHandler: { (statusCode) in
                    print(statusCode)
                }) { (errorCode) in
                    print(errorCode)
                }
            } else {
                 self.view.makeToast("This feature is not supported in guest mode!", duration: 2, point: center, title: "Info", image: nil, style: style, completion: nil)
            }
            
        case MoviePopUpOption.playLastTrailer.rawValue:
            
            // Play the last trailer of the TV-Show
            
            let dispatcher = NetworkingDispatcher(environment: evrment)
            
            let getVideoOfMovie = GetVideoOfMovieService(id: String(movie.id))
            
            getVideoOfMovie.execute(in: dispatcher, completionHandler: { (videos) in
                let lastVideo = videos.last
                
                self.playVideo(videoIdentifier: lastVideo?.key)
            }, failureBlock: { (errorCode) in
                print(errorCode)
            })
            
            
        case MoviePopUpOption.showAllDetail.rawValue:
            
            // Present the tvShow detail view controller
            
            let layout = UICollectionViewFlowLayout()
            
            let vc = MovieDetailController(collectionViewLayout: layout)
            
            vc.movieID = movie.id
            
            vc.interactor = interactor
            
            vc.transitioningDelegate = self
            
            present(vc, animated: true, completion: nil)
            
            
        default:
            print("foo")
        }
    }
}





