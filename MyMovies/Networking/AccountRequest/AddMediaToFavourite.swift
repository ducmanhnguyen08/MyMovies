//
//  AddMovieToFavourite.swift
//  MyMovies


import Foundation
import SwiftyJSON

enum AddMediaToFavouriteStatusCode: Int {
    case successRemoveFromFavourite = 13
    case successAddToFavourite = 1
    case failToAdd = -1
}

class AddMediaToFavourite: Service {
    
    func execute(in dispatcher: Dispatcher, completionHandler: @escaping (AddMediaToFavouriteStatusCode) -> (), failureBlock: @escaping (Int?) -> ()) {
        do {
            try dispatcher.execute(request: request, completionHandler: { (response) in
                switch response {
                case .json(let json):
                    print(json)
                case .error(let errorCode, let error):
                    failureBlock(errorCode)
                default:
                    ()
                }
            })
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    var request: Request
    
    typealias output = AddMediaToFavouriteStatusCode
    
    init(mediaType: String, mediaId: Int, favourite: Bool) {
        self.request = AccountRequest.addToFavourite(mediaType: mediaType, mediaId: mediaId, favourite: favourite)
    }
}
