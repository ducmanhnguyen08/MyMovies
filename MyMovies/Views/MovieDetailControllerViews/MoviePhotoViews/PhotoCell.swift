//
//  PhotoCell.swift
//  MyMovies


import Foundation
import UIKit
import SDWebImage

class PhotoCell: UICollectionViewCell {
    
    var image: Image? {
        didSet {
            guard let image = image else { return }
            guard let url = URL(string: image.file_path) else { return }
            photoView.sd_setImage(with: url, completed: nil)
        }
    }
    
    let photoView: UIImageView = {
        let photo = UIImageView()
        photo.image = #imageLiteral(resourceName: "back_drop_image")
        photo.contentMode = .scaleAspectFill
        photo.clipsToBounds = true
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
        addSubview(photoView)
        
        photoView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
}
