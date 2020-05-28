//
//  MovieDetailPhotoCell.swift
//  MyMovies

import Foundation
import UIKit
import DZNEmptyDataSet
import INSPhotoGallery

protocol MovieDetailPhotoCellDelegate {
    func movieDetailPhotoCell(didSelectPhotoAtIndex indexPath: IndexPath)
}

extension MovieDetailPhotoCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.width - 50, height: self.bounds.height - 30)
    }
}

extension MovieDetailPhotoCell: UICollectionViewDelegate, UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! PhotoCell
        guard let photos = photos else {
            return cell
        }
        cell.image = photos[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let photos = photos else { return 0 }
        
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let photos = photos else { return }
        let cell = collectionView.cellForItem(at: indexPath) as! PhotoCell
        let vc = INSPhotosViewController(photos: photos, initialPhoto: photos[indexPath.item], referenceView: cell)
        
        vc.referenceViewForPhotoWhenDismissingHandler = { photo in
            if let index = photos.index(where: {$0 === photo}) {
                let indexPath = IndexPath(item: index, section: 0)
                return collectionView.cellForItem(at: indexPath) as? PhotoCell
            }
            return nil
        }
        
        delegate?.movieDetailPhotoCell(didSelectPhotoAtIndex: indexPath)
        
    }
}

class MovieDetailPhotoCell: UICollectionViewCell, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    let cellID = "cellID"
    
    var delegate: MovieDetailPhotoCellDelegate?
    
    var photos: [Image]? {
        didSet {
            guard let photos = photos else { return }
            photoCollectionView.reloadData()
        }
    }
    
    let photoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "sad")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "There are no images for this movie now!"
        let attribs = [NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 16)!, NSAttributedString.Key.foregroundColor: UIColor.tvShowCellTextColor()]
        
        return  NSAttributedString(string: text, attributes: attribs)
    }
    
    let photoIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = #imageLiteral(resourceName: "picture")
        icon.contentMode = .scaleAspectFit
        icon.clipsToBounds = true
        return icon
    }()
    
    let photolbl: UILabel = {
        let photo = UILabel()
        photo.text = "Photos:"
        photo.font = UIFont(name: "Avenir-Heavy", size: 15)!
        photo.textColor = .white
        return photo
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        photoCollectionView.delegate = self
        photoCollectionView.dataSource = self
        photoCollectionView.emptyDataSetSource = self
        photoCollectionView.emptyDataSetDelegate = self
        
        photoCollectionView.register(PhotoCell.self, forCellWithReuseIdentifier: cellID)
        
        
        addSubview(photoIcon)
        addSubview(photolbl)
        addSubview(photoCollectionView)
        
        photoIcon.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 25, height: 30)
        
        photolbl.anchor(top: topAnchor, left: photoIcon.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 100, height: 30)
        photoCollectionView.anchor(top: photolbl.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
}





