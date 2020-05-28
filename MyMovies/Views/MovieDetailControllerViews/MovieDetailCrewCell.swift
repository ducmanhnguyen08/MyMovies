//
//  MovieDetailCrewCell.swift
//  MyMovies

import Foundation
import UIKit
import DZNEmptyDataSet

extension MovieDetailCrewCell: DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return #imageLiteral(resourceName: "sad")
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        let text = "There is no info for this section for now!"
        let attribs = [NSAttributedString.Key.font: UIFont(name: "Avenir-Heavy", size: 16)!, NSAttributedString.Key.foregroundColor: UIColor.tvShowCellTextColor()]
        
        return  NSAttributedString(string: text, attributes: attribs)
    }
}

extension MovieDetailCrewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.height - 30, height: self.bounds.height - 30)
    }
}

extension MovieDetailCrewCell: UICollectionViewDelegate, UICollectionViewDataSource  {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! CastCell
        
        guard let casts = castList else {
            return cell
        }
        
        cell.cast = casts[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let casts = castList else { return 0 }
        
        return casts.count
    }
}

class MovieDetailCrewCell: UICollectionViewCell {
    
    let cellID = "cellID"
    
    var castList: [Cast]? {
        didSet {
            crewCollectionView.reloadData()
        }
    }
    
    let crewCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    let userIcon: UIImageView = {
        let icon = UIImageView()
        icon.image = #imageLiteral(resourceName: "user")
        icon.contentMode = .scaleAspectFit
        icon.clipsToBounds = true
        return icon
    }()
    
    let crewLbl: UILabel = {
        let photo = UILabel()
        photo.text = "Casting:"
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
        backgroundColor = .clear
        
        crewCollectionView.delegate = self
        crewCollectionView.dataSource = self
        crewCollectionView.emptyDataSetDelegate = self
        crewCollectionView.emptyDataSetSource = self
        
        crewCollectionView.register(CastCell.self, forCellWithReuseIdentifier: cellID)
        
        addSubview(userIcon)
        addSubview(crewLbl)
        addSubview(crewCollectionView)
        
        userIcon.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 25, height: 30)
        
        crewLbl.anchor(top: topAnchor, left: userIcon.rightAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 100, height: 30)
        crewCollectionView.anchor(top: crewLbl.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
}






