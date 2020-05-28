//
//  MyRatingMovieCell.swift
//  MyMovies


import Foundation
import UIKit

protocol MyRatingMovieCellDelegate {
    func myRatingMovieCellDidRemoveCell(movie: Movie)
}

class MyRatingMovieCell: MovieCell {
    
    var delegate: MyRatingMovieCellDelegate?
    
    override var movie: Movie? {
        didSet {
            guard let movie = movie else { return }
            
            ratingLbl.text = String(describing: movie.rating ?? 0)
            
            removeBtn.isHidden = !isEditing
        }
    }
    
    var isEditing: Bool = false {
        didSet {
            removeBtn.isHidden = !isEditing
        }
    }
    
    lazy var removeBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(#imageLiteral(resourceName: "delete").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleRemoveItem), for: .touchUpInside)
        btn.backgroundColor = .clear
        return btn
    }()
    
    lazy var ratingLbl: CustomLabel = {
        let lbl = CustomLabel()
        lbl.text = "7"
        lbl.textColor = .white
        lbl.font = UIFont(name: "Avenir-Heavy", size: 18)
        lbl.textAlignment = .right
        return lbl
    }()
    
    lazy var starIcon: UIImageView = {
        let ic = UIImageView()
        ic.image = #imageLiteral(resourceName: "star (1)")
        ic.contentMode = .scaleAspectFit
        ic.clipsToBounds = true
        return ic
    }()
    
    lazy var dimBg: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.3)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
        posterImageView.addSubview(dimBg)
        
        posterImageView.addSubview(removeBtn)
        
        dimBg.addSubview(starIcon)
        
        dimBg.addSubview(ratingLbl)
        
        dimBg.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        starIcon.anchor(top: dimBg.topAnchor, left: nil, bottom: dimBg.bottomAnchor, right: dimBg.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 5, paddingRight: 5, width: 30, height: 0)
        
        ratingLbl.anchor(top: dimBg.topAnchor, left: nil, bottom: dimBg.bottomAnchor, right: starIcon.leftAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 5, paddingRight: 5, width: 50, height: 0)
        
        removeBtn.anchor(top: posterImageView.topAnchor, left: posterImageView.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 5, paddingBottom: 0, paddingRight: 0, width: 30, height: 30)
    }
    
    @objc fileprivate func handleRemoveItem() {
        
        guard let movie = movie else { return }
        
        delegate?.myRatingMovieCellDidRemoveCell(movie: movie)
    }
}
