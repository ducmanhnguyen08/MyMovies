//
//  Image.swift
//  MyMovies


import Foundation
import SwiftyJSON
import SDWebImage
import INSPhotoGallery

class Image: NSObject, INSPhotoViewable {
    
    var image: UIImage?
    
    var thumbnailImage: UIImage?
    
    func loadImageWithCompletionHandler(_ completion: @escaping (UIImage?, Error?) -> ()) {
        SDWebImageManager.shared().imageDownloader?.downloadImage(with: URL(string: file_path), options: .highPriority, progress: nil, completed: { (image, data, err, bool) in
            self.image = image
            completion(image, nil)
        })
    }
    
    func loadThumbnailImageWithCompletionHandler(_ completion: @escaping (UIImage?, Error?) -> ()) {
        self.thumbnailImage = #imageLiteral(resourceName: "frame-landscape")
        completion(#imageLiteral(resourceName: "frame-landscape"), nil)
    }
    
    var attributedTitle: NSAttributedString?
    
    
    let file_path: String
    let width: Int
    
    init(json: JSON) {
        self.file_path = "https://image.tmdb.org/t/p/w500" + json["file_path"].stringValue
        self.width = json["width"].intValue
    }
    
    
    
}
