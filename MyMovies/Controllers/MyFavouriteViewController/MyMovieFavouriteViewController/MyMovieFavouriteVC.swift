//
//  MyMovieFavouriteVC.swift
//  MyMovies


import Foundation
import UIKit
import SwiftyJSON
import MBProgressHUD

protocol MyMoviesFavouriteViewControllerDelegate {
    func myMoviesFavouriteViewControllerDelegate(viewController: UIViewController, didSelectMovie movie: Movie)
}

extension MyMovieFavouriteViewController: UICollectionViewDelegateFlowLayout {
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

class MyMovieFavouriteViewController: UICollectionViewController {
    
    let cellID = "cellID"
    
    var delegate: MyMoviesFavouriteViewControllerDelegate?
    
    var favouriteMovies = [Movie]() {
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
        return favouriteMovies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MovieCell
        cell.movie = favouriteMovies[indexPath.item]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.myMoviesFavouriteViewControllerDelegate(viewController: self, didSelectMovie: favouriteMovies[indexPath.item])
        
    }
    
    //MARK: Setup methods
    
    fileprivate func setupCollectionView() {
        collectionView?.backgroundColor = UIColor.mainColor()
        collectionView?.register(MovieCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        getListOfRatingMovies(completionHandler: {
            MBProgressHUD.hide(for: self.collectionView!, animated: true)
        })
    }
    
    func getListOfRatingMovies(completionHandler: @escaping () -> ()) {
        let evrment = Environment(name: "Test", host: Constant.ACCOUNT_HOSTNAME)
        let dispatcher = NetworkingDispatcher(environment: evrment)
        MBProgressHUD.showAdded(to: collectionView!, animated: true)
        let service = GetFavouriteMoviesService()
        
        service.execute(in: dispatcher, completionHandler: { (movies) in
            self.favouriteMovies = movies
            
            completionHandler()
        }) { (errorCode) in
            print(errorCode)
        }
    }
}





