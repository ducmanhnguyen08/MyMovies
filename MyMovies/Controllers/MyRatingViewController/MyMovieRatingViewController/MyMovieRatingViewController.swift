//
//  MyMovieRatingViewController.swift
//  MyMovies


import Foundation
import UIKit
import SwiftyJSON
import MBProgressHUD

extension MyMovieRatingViewController: MyRatingMovieCellDelegate {
    func myRatingMovieCellDidRemoveCell(movie: Movie) {
        if let indexPath = ratingMovies.index(of: movie) {
            self.collectionView?.performBatchUpdates({
                
                let deleteRatingMovieService = DeleteMovieRatingService(id: String(self.ratingMovies[indexPath].id))
                
                deleteRatingMovieService.execute(in: dispatch, completionHandler: { (statusCode) in
                    print(statusCode.rawValue)
                }, failureBlock: { (errorCode) in
                    print(errorCode)
                })
                
                self.ratingMovies.remove(at: indexPath)
                self.collectionView?.deleteItems(at: [IndexPath(item: indexPath, section: 0)])
            }, completion: nil)
        }
    }
}

extension MyMovieRatingViewController: UICollectionViewDelegateFlowLayout {
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

class MyMovieRatingViewController: UICollectionViewController {
    
    let cellID = "cellID"
    
    lazy var dispatch = NetworkingDispatcher(environment: Environment(name: "Production", host: Constant.MOVIE_HOSTNAME))
    
    var ratingMovies = [Movie]() {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    override var isEditing: Bool {
        didSet {
            self.collectionView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionView()
    }
    
    // MARK: CollectionView's config
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ratingMovies.count
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MyRatingMovieCell
        cell.movie = ratingMovies[indexPath.item]
        cell.isEditing = self.isEditing
        cell.delegate = self
        return cell
    }
    
    // MARK: Delete cell
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
    }
    
    //MARK: Setup methods
    
    fileprivate func setupCollectionView() {
        collectionView?.backgroundColor = UIColor.mainColor()
        collectionView?.register(MyRatingMovieCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        getListOfRatingMovies(completionHandler: {
            MBProgressHUD.hide(for: self.collectionView!, animated: true)
        })
    }
    
    fileprivate func getListOfRatingMovies(completionHandler: @escaping () -> ()) {
        let evrment = Environment(name: "Test", host: Constant.ACCOUNT_HOSTNAME)
        let dispatcher = NetworkingDispatcher(environment: evrment)
        MBProgressHUD.showAdded(to: collectionView!, animated: true)
        let service = GetRatedMovieService()
        
        service.execute(in: dispatcher, completionHandler: { (movies) in
            self.ratingMovies = movies
            
            completionHandler()
        }) { (errorCode) in
            print(errorCode)
        }
    }
}
