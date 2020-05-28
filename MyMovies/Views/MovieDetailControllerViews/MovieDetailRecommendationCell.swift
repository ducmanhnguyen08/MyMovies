//
//  MovieDetailRecommendationCell.swift
//  MyMovies


import Foundation
import UIKit
import DZNEmptyDataSet

public protocol MovieDetailRecommendationCellDelegate {
    func movieDetailRecommendationCellDidSelectItem(id: Int)
}

extension MovieDetailRecommendationCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.width / 3, height: self.bounds.width / 3 * 1.6)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension MovieDetailRecommendationCell: UICollectionViewDelegate, UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! RecommendationCell
        guard let recommendations = recommendationMovies else { return cell }
        cell.movie = recommendations[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let recommendations = recommendationMovies else { return 0 }
        
        return recommendations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let recommendationMovies = recommendationMovies else { return }
        delegate?.movieDetailRecommendationCellDidSelectItem(id: recommendationMovies[indexPath.item].id)
    }
}

class MovieDetailRecommendationCell: UICollectionViewCell, DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    var delegate: MovieDetailRecommendationCellDelegate?
    
    var recommendationMovies: [Movie]? {
        didSet {
            recommendedMoviesCollectionView.reloadData()
        }
    }
    
    let cellID = "cellId"
    
    let recommendedMoviesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        return collectionView
    }()
    
    let recommendTitle: UILabel = {
        let title = UILabel()
        title.attributedText = createAttributedTextForRating(firstString: "people who like this\n".uppercased(), secondString: "aslo liked:".uppercased())
        title.textAlignment = .center
        title.backgroundColor = UIColor.mainColor()
        title.numberOfLines = 0
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews() {
        recommendedMoviesCollectionView.emptyDataSetSource = self
        recommendedMoviesCollectionView.emptyDataSetDelegate = self
        recommendedMoviesCollectionView.delegate = self
        recommendedMoviesCollectionView.dataSource = self
        recommendedMoviesCollectionView.register(RecommendationCell.self, forCellWithReuseIdentifier: cellID)
        
        addSubview(recommendTitle)
        addSubview(recommendedMoviesCollectionView)
        
        recommendTitle.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 100)
        recommendedMoviesCollectionView.anchor(top: recommendTitle.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    fileprivate static func createAttributedTextForRating(firstString: String, secondString: String) -> NSAttributedString {
        
        let firstAttributedString = NSMutableAttributedString(string: firstString, attributes: [NSAttributedString.Key.font : UIFont(name: "Avenir-Heavy", size: 15)!, NSAttributedString.Key.foregroundColor : UIColor.tvShowCellTextColor()])
        firstAttributedString.append(NSMutableAttributedString(string: secondString, attributes: [NSAttributedString.Key.font : UIFont(name: "Avenir-Heavy", size: 15)!, NSAttributedString.Key.foregroundColor : UIColor.white]))
        
        return firstAttributedString
    }
    
    // MARK: Empty state view
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "sad")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "We are sorry. There are no recommendations for this movie now!"
        let attribs = [NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 16)!, NSAttributedString.Key.foregroundColor: UIColor.tvShowCellTextColor()]
        
        return  NSAttributedString(string: text, attributes: attribs)
    }
}



