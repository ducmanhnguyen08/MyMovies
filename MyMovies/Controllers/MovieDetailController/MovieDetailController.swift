//
//  MovieDetailController.swift
//  MyMovies


import Foundation
import UIKit
import MBProgressHUD
import SDWebImage
import XCDYouTubeKit
import AVKit
import INSPhotoGallery
import Toast_Swift

extension MovieDetailController: MovieDetailHeaderDelegate {
    
    func movieDetailHeaderIsInGuestMode() {
        print("Handle guest mode")
        
        var style = ToastStyle()
        
        style.backgroundColor = .black
        
        style.messageNumberOfLines = 1
        
        style.titleAlignment = .center
        
        let center = self.view.center
        
        self.view.makeToast("This feature is not supported in guest mode!", duration: 2, point: center, title: "Info", image: nil, style: style, completion: nil)
    }
    
    func movieDetailHeaderDidRateMovie(withRating rating: Double) {
        
        if let id = movieID {
            let dispatcher = NetworkingDispatcher(environment: evrment)
            
            let rateMovieService = RatingMovieService(id: String(id), rating: rating)
            
            rateMovieService.execute(in: dispatcher, completionHandler: { (statusCode) in
                switch statusCode {
                case .successRating , .successUpdate:
                    print("OK")
                case .failToRate:
                    print("Not ok")
                }
            }, failureBlock: { (errorCode) in
                print(errorCode)
            })
        }
    }
    
    func movieDetailHeaderDidClickFavouriteButton(mediaId: Int, favourite: Bool) {
        let dispatcher = NetworkingDispatcher(environment: userEnvironment)
        
        if let isFavourite = movie?.isFavourite {
            if isFavourite != favourite {
                Constant.shouldReloadFavouriteMovie = true
            }
        }
        
        let addToFavouriteService = AddMediaToFavourite(mediaType: "movie", mediaId: mediaId, favourite: favourite)
        
        addToFavouriteService.execute(in: dispatcher, completionHandler: { (statusCode) in
            print(statusCode.rawValue)
        }) { (errorCode) in
            print(errorCode)
        }
    }
    
    func movieDetailHeaderDidClickWatchListButton(mediaId: Int, watchlist: Bool) {
        let dispatcher = NetworkingDispatcher(environment: userEnvironment)
        let addToWatchListService = AddMediaToWatchListService(mediaType: "movie", mediaID: mediaId, watchList: watchlist)
        Constant.shouldReloadWatchlistMovie = true
        addToWatchListService.execute(in: dispatcher, completionHandler: { (statusCode) in
            switch statusCode {
            case .successAddToWatchList:
                
                let deviceType = IphoneDeviceManager.currentDevice.getDeviceType()
                
                if deviceType == IphoneDevicetype.otherIphone {
                    WatchListStatusIndicator.shared.showIndicator(state: .addMovieToWatchList)
                }
            case .successRemoveFromWatchList:
                
                let deviceType = IphoneDeviceManager.currentDevice.getDeviceType()
                
                if deviceType == IphoneDevicetype.otherIphone {
                    WatchListStatusIndicator.shared.showIndicator(state: .removeFromWatchList)
                }
                
            case .failToAdd:
                print("Failed to add")
            }
        }) { (errorCode) in
            print(errorCode)
        }
    }
}

extension MovieDetailController: MovieDetailPhotoCellDelegate {
    func movieDetailPhotoCell(didSelectPhotoAtIndex indexPath: IndexPath) {
        guard let photos = imageList else { return }
        guard let photoCell = collectionView?.cellForItem(at: IndexPath(item: 2, section: 0)) as? MovieDetailPhotoCell else { return }
        guard let referenceCell = photoCell.photoCollectionView.cellForItem(at: indexPath) as? PhotoCell else { return }
        let vc = INSPhotosViewController(photos: photos, initialPhoto: photos[indexPath.item], referenceView: referenceCell)
        
        present(vc, animated: true, completion: nil)
    }
}

extension MovieDetailController: MovieDetailRecommendationCellDelegate {
    func movieDetailRecommendationCellDidSelectItem(id: Int) {
        let layout = UICollectionViewFlowLayout()
        let vc = MovieDetailController(collectionViewLayout: layout)
        vc.movieID = id
        navigationController?.pushViewController(vc, animated: true)
    }
}


extension MovieDetailController: MovieDetailVideoCellDelegate {
    func movieDetailVideoCell(didSelectVideoWithKey key: String) {
        playVideo(videoIdentifier: key)
    }
}

extension MovieDetailController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.bounds.width, height: view.bounds.width * 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.item {
        case 0:
            
            guard let movie = movie else { return  CGSize(width: view.bounds.width, height: 200) }
            
            let estimatedHeight = movie.overview.height(withConstrainedWidth: view.frame.width - 20, font: UIFont(name: "Avenir-Medium", size: 13)!)
            
            print(estimatedHeight)
            
            return CGSize(width: view.bounds.width, height: estimatedHeight + 60)
        case 1:
            print(1)
            return CGSize(width: view.bounds.width, height: 250)
            
        case 2:
            print(2)
            return CGSize(width: view.bounds.width, height: 230)
            
        case 3:
            print(3)
            return CGSize(width: view.bounds.width, height: 200)
            
        case 4:
            print(4)
            return CGSize(width: view.bounds.width, height: 100 + view.bounds.width / 3 * 1.6)
            
        default:
            return CGSize(width: 50, height: 50)
        }
    }
}

class MovieDetailController: UICollectionViewController {
    
    let cellID = "cellID"
    let headerID = "headerID"
    let overViewCell = "overviewCell"
    let videoCellID = "videoCell"
    let photoCellID = "photoCell"
    let crewCellID = "crewCell"
    let recommendationCellID = "recommendationID"
    let evrment = Environment(name: "Test", host: Constant.MOVIE_HOSTNAME)
    let userEnvironment = Environment(name: "Test", host: Constant.ACCOUNT_HOSTNAME)
    var interactor : Interactor? = nil
    
    
    var movieID: Int? {
        didSet {
            guard let id = movieID else { return }
            let dispatcher = NetworkingDispatcher(environment: evrment)
            let getMovieWithId = GetMovieWithIDService(id: String(id))
            MBProgressHUD.showAdded(to: view, animated: true)
            print(id)
            
            getMovieWithId.execute(in: dispatcher, completionHandler: { (movie) in
                self.movie = movie
            }) { (errorCode) in
                print(errorCode)
            }
        }
    }
    
    var movie: Movie? {
        didSet {
            
            guard let movie = movie else { return }
            
            let dispatcher = NetworkingDispatcher(environment: evrment)
            
            let getVideoOfMovie = GetVideoOfMovieService(id: String(movie.id))
            
            getVideoOfMovie.execute(in: dispatcher, completionHandler: { (videos) in
                self.videoList = videos
            }) { (errorCode) in
                print(errorCode)
            }
            
            let getImageOfMovie = GetImageOfMovieService(id: String(movie.id))
            
            getImageOfMovie.execute(in: dispatcher, completionHandler: { (images) in
                self.imageList = images
            }) { (errorCode) in
                print(errorCode)
            }
            
            let getCastOfMovie = GetCastOfMovieService(id: String(movie.id))
            
            getCastOfMovie.execute(in: dispatcher, completionHandler: { (casts) in
                self.castList = casts
            }) { (errorCode) in
                print(errorCode)
            }
            
            let getRecommendation = GetRecommendationOfMovie(id: String(movie.id))
            
            getRecommendation.execute(in: dispatcher, completionHandler: { (recommendations) in
                self.recommendations = recommendations
            }) { (errorCode) in
                print(errorCode)
            }
            
            guard let currentUser = UserSessionController.shared.getCurrentUser() else { return }
            
            if currentUser.sessionType == .imbdUser {
                let getAccountState = GetAccountStateWithMovie(id: String(movie.id))
                
                getAccountState.execute(in: dispatcher, completionHandler: { (userState) in
                    self.userState = userState
                    
                    
                }) { (errorCode) in
                    print(errorCode)
                }
            }
            
            collectionView?.reloadData()
            
            MBProgressHUD.hide(for: view, animated: true)
        }
    }
    
    var userState: MovieUserState? {
        didSet {
            movie?.rating = userState?.rating ?? 0
            movie?.isFavourite = userState?.isFavourite
            movie?.isInWatchList = userState?.isWatchList
            self.collectionView?.reloadData()
        }
    }
    
    var videoList: [Video]? {
        didSet {
            collectionView?.reloadItems(at: [IndexPath(item: 1, section: 0)])
        }
    }
    
    var imageList: [Image]? {
        didSet {
            collectionView?.reloadItems(at: [IndexPath(item: 2, section: 0)])
        }
    }
    
    var castList: [Cast]? {
        didSet {
            collectionView?.reloadItems(at: [IndexPath(item: 3, section: 0)])
        }
    }
    
    var recommendations: [Movie]? {
        didSet {
            collectionView?.reloadItems(at: [IndexPath(item: 4, section: 0)])
        }
    }
    
    let movieTitle: CustomLabel = {
        let movie = CustomLabel()
        movie.text = "Movie"
        movie.font = UIFont(name: "Avenir-Heavy", size: 17)
        movie.textColor = .white
        return movie
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let rootVC = self.navigationController?.viewControllers.first else { return }
        
        if self == rootVC {
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "cancel-music"), style: .plain, target: self, action: #selector(handleCloseMovieDetail))
        }
    }
    
    
    fileprivate func setupCollectionView() {
        collectionView?.backgroundColor = UIColor.mainColor()
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.register(MovieDetailOverViewCell.self, forCellWithReuseIdentifier: overViewCell)
        collectionView?.register(MovieDetailVideoCell.self, forCellWithReuseIdentifier: videoCellID)
        collectionView?.register(MovieDetailPhotoCell.self, forCellWithReuseIdentifier: photoCellID)
        collectionView?.register(MovieDetailCrewCell.self, forCellWithReuseIdentifier: crewCellID)
        collectionView?.register(MovieDetailRecommendationCell.self, forCellWithReuseIdentifier: recommendationCellID)
        collectionView?.register(MovieDetailHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID)
        
        setupNavigationBar()
        
        collectionView?.panGestureRecognizer.addTarget(self, action: #selector(handleGesture(sender:)))
    }
    
    fileprivate func setupNavigationBar() {
        navigationItem.titleView = movieTitle
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: CollectionView's config
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.item {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: overViewCell, for: indexPath) as! MovieDetailOverViewCell
            cell.overView = movie?.overview
            return cell
        case 1:
            let videoCell = collectionView.dequeueReusableCell(withReuseIdentifier: videoCellID, for: indexPath) as! MovieDetailVideoCell
            videoCell.videoList = self.videoList
            videoCell.delegate = self
            return videoCell
        case 2:
            let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellID, for: indexPath) as! MovieDetailPhotoCell
            photoCell.photos = imageList
            photoCell.delegate = self
            return photoCell
        case 3:
            let crewCell = collectionView.dequeueReusableCell(withReuseIdentifier: crewCellID, for: indexPath) as! MovieDetailCrewCell
            crewCell.castList = self.castList
            return crewCell
        case 4:
            let recommendationCell = collectionView.dequeueReusableCell(withReuseIdentifier: recommendationCellID, for: indexPath) as! MovieDetailRecommendationCell
            recommendationCell.recommendationMovies = recommendations
            recommendationCell.delegate = self
            return recommendationCell
        default:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
            cell.backgroundColor = .red
            return cell
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID, for: indexPath) as! MovieDetailHeader
        
        header.delegate = self
        header.movie = self.movie
        header.setNeedsLayout()
        header.layoutIfNeeded()
        
        return header
    }
    
    // MARK: setup method
    
    @objc private func handleCloseMovieDetail() {
        self.dismiss(animated: true, completion: nil)
    }
    
    public static func createAttributedTextForRating(firstString: String, secondString: String) -> NSAttributedString {
        
        let firstAttributedString = NSMutableAttributedString(string: firstString, attributes: [NSAttributedString.Key.font : UIFont(name: "AvenirNext-Bold", size: 23)!, NSAttributedString.Key.foregroundColor : UIColor.movieTintColor()])
        firstAttributedString.append(NSMutableAttributedString(string: secondString, attributes: [NSAttributedString.Key.font : UIFont(name: "Avenir-Book", size: 12)!, NSAttributedString.Key.foregroundColor : UIColor.tvShowCellTextColor()]))
        
        return firstAttributedString
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
    
    func progressAlongAxis(pointOnAxis: CGFloat, axisLength: CGFloat) -> CGFloat {
        let movementOnAxis = pointOnAxis / axisLength
        let positiveMovementOnAxis = fmaxf(Float(movementOnAxis), 0.0)
        let positiveMovementOnAxisPercent = fminf(positiveMovementOnAxis, 1.0)
        return CGFloat(positiveMovementOnAxisPercent)
    }
    
    @objc fileprivate func handleGesture(sender: UIPanGestureRecognizer) {
        
        let percentThreshold:CGFloat = 0.3
        
        let translation = sender.translation(in: collectionView)
        
        let progress = progressAlongAxis(pointOnAxis: translation.y, axisLength: view.bounds.height)
        
        guard let interactor = interactor,
            let originView = sender.view else { return }
        
        print(progress, translation)
        
        print((collectionView?.contentOffset.y)! + 24)
        
        switch originView {
        case view:
            break
        case collectionView!:
            if ((collectionView?.contentOffset.y)! + 21) >= CGFloat(0) {
                return
            }
        default:
            break
        }
        
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()
        default:
            break
        }
    }
    
}









