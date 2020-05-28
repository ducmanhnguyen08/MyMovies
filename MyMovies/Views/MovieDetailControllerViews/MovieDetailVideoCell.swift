//
//  MovieDetailVideoCell.swift
//  MyMovies

import Foundation
import UIKit
import DZNEmptyDataSet

protocol MovieDetailVideoCellDelegate {
    func movieDetailVideoCell(didSelectVideoWithKey key: String)
}

extension MovieDetailVideoCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.width - 50, height: self.bounds.height - 30)
    }
}

extension MovieDetailVideoCell: UICollectionViewDelegate, UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MovieTrailerCell
        guard let videos = videoList else {
            return cell
        }
        cell.video = videos[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let videos = videoList {
            return videos.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let videoList = videoList {
            delegate?.movieDetailVideoCell(didSelectVideoWithKey: videoList[indexPath.item].key)
        }
    }
}

class MovieDetailVideoCell: UICollectionViewCell, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    let cellID = "cellID"
    
    var delegate: MovieDetailVideoCellDelegate?
    
    var videoList: [Video]? {
        didSet {
            trailerCollectionView.reloadData()
        }
    }
    
    let trailerCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    let videoIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = #imageLiteral(resourceName: "video-player")
        icon.contentMode = .scaleAspectFit
        icon.clipsToBounds = true
        return icon
    }()
    
    let videoTrailer: UILabel = {
        let trailer = UILabel()
        trailer.text = "Trailers:"
        trailer.font = UIFont(name: "Avenir-Heavy", size: 15)!
        trailer.textColor = .white
        return trailer
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        trailerCollectionView.delegate = self
        trailerCollectionView.dataSource = self
        trailerCollectionView.emptyDataSetSource = self
        trailerCollectionView.emptyDataSetDelegate = self
        trailerCollectionView.register(MovieTrailerCell.self, forCellWithReuseIdentifier: cellID)
        
        addSubview(videoIcon)
        addSubview(videoTrailer)
        addSubview(trailerCollectionView)
        
        videoIcon.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 25, height: 30)
        
        videoTrailer.anchor(top: topAnchor, left: videoIcon.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 100, height: 30)
        trailerCollectionView.anchor(top: videoTrailer.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    // MARK: Empty state view
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "sad")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "There are no videos for this movie now!"
        let attribs = [NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 16)!, NSAttributedString.Key.foregroundColor: UIColor.tvShowCellTextColor()]
        
        return  NSAttributedString(string: text, attributes: attribs)
    }
}





