//
//  MovieViewController.swift
//  MyMovies
//
import UIKit
import Foundation
import MBProgressHUD

public protocol UpcomingMovieViewControllerDelegate {
    
    func upcomingMovieViewController(viewController: UIViewController, didSelectMovieWithID id: Int)
}

extension UpcomingMovieViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width) / 2
        return CGSize(width: width, height: width * 85 / 57)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

class UpcomingMovieViewController: UICollectionViewController, UIGestureRecognizerDelegate {
    
    let cellID = "cellID"
    var delegate: UpcomingMovieViewControllerDelegate?
    
    private lazy var refresher: UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.tintColor = .lightGray
        rf.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        rf.addTarget(self, action: #selector(handleRefreshing), for: .valueChanged)
        return rf
    }()
    
    var upComingMovies = [Movie]() {
        didSet {
            self.collectionView?.reloadData()
            self.refresher.endRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
        
        setupLongPressRecognizer()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        
    }
    
    // MARK: CollectionView's config
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return upComingMovies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MovieCell
        cell.movie = upComingMovies[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.upcomingMovieViewController(viewController: self, didSelectMovieWithID: upComingMovies[indexPath.item].id)
        
    }
    
    //MARK: Setup methods
    
    @objc fileprivate func handleRefreshing() {
        
        let evrment = Environment(name: "Test", host: Constant.MOVIE_HOSTNAME)
        let dispatcher = NetworkingDispatcher(environment: evrment)
        
        let service = GetUpcomingMovieService()
        self.refresher.beginRefreshing()
        service.execute(in: dispatcher, completionHandler: { (movies) in
            self.upComingMovies = movies
        }) { (errorCode) in
            print(errorCode)
            self.refresher.endRefreshing()
        }
        
    }
    
    fileprivate func setupCollectionView() {
        collectionView?.backgroundColor = UIColor.mainColor()
        collectionView?.register(MovieCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.addSubview(refresher)
        
        getListOfUpcomingMovies()
    }
    
    fileprivate func getListOfUpcomingMovies() {
        let evrment = Environment(name: "Test", host: Constant.MOVIE_HOSTNAME)
        let dispatcher = NetworkingDispatcher(environment: evrment)
        MBProgressHUD.showAdded(to: collectionView!, animated: true)
        let service = GetUpcomingMovieService()
        
        service.execute(in: dispatcher, completionHandler: { (movies) in
            self.upComingMovies = movies
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.collectionView!, animated: true)
            }
        }) { (errorCode) in
            print(errorCode)
        }
    }
    
    @objc func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        if gestureReconizer.state != UIGestureRecognizer.State.ended {
            return
        }

        let p = gestureReconizer.location(in: self.collectionView)
        let indexPath = self.collectionView?.indexPathForItem(at: p)

        if let index = indexPath {
            var cell = self.collectionView?.cellForItem(at: index)
            
            print(index)
            let vc = MoviePopUpViewController()
            vc.movie = self.upComingMovies[index.item]
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            
            self.definesPresentationContext = true
            
            
            self.present(vc, animated: true, completion: nil)
        
        } else {
            print("Could not find index path")
        }
        
    }
    
    fileprivate func setupLongPressRecognizer() {
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureReconizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        lpgr.delegate = self
        self.collectionView?.addGestureRecognizer(lpgr)
    }
    
}













