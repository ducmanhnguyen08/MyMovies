//
//  PopularMovieViewController.swift
//  MyMovies

import UIKit
import MBProgressHUD
import Foundation

public protocol PopularMovieViewControllerDelegate: class {
    
    func popularMovieViewController(viewController: UIViewController, didSelectMovieWithID id: Int)
}


extension PopularMovieViewController: UICollectionViewDelegateFlowLayout {
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

class PopularMovieViewController: UICollectionViewController, UIGestureRecognizerDelegate {
    
    let cellID = "cellID"
    
    var delegate: PopularMovieViewControllerDelegate?
    
    private lazy var refresher: UIRefreshControl = {
        let rf = UIRefreshControl()
        rf.tintColor = .lightGray
        rf.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        rf.addTarget(self, action: #selector(handleRefreshing), for: .valueChanged)
        return rf
    }()
    
    var popularMovies = [Movie]() {
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
    
    // MARK: CollectionView's config
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularMovies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MovieCell
        cell.movie = popularMovies[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.popularMovieViewController(viewController: self, didSelectMovieWithID: popularMovies[indexPath.item].id)
    }
    
    //MARK: Setup methods
    
    @objc fileprivate func handleRefreshing() {
        
        let evrment = Environment(name: "Test", host: Constant.MOVIE_HOSTNAME)
        let dispatcher = NetworkingDispatcher(environment: evrment)
        
        let service = GetPopularMovieService()
        self.refresher.beginRefreshing()
        service.execute(in: dispatcher, completionHandler: { (movies) in
            self.popularMovies = movies
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
        
        getListOfPopularMovies()
    }
    
    fileprivate func getListOfPopularMovies() {
        let evrment = Environment(name: "Test", host: Constant.MOVIE_HOSTNAME)
        let dispatcher = NetworkingDispatcher(environment: evrment)
        MBProgressHUD.showAdded(to: collectionView!, animated: true)
        let service = GetPopularMovieService()
        
        service.execute(in: dispatcher, completionHandler: { (movies) in
            self.popularMovies = movies
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
            vc.movie = self.popularMovies[index.item]
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
