//
//  AddMediaToWatchListService.swift
//  MyMovies

import Foundation
import SwiftyJSON

enum AddMediaToWatchListStatusCode: Int {
    case successRemoveFromWatchList = 13
    case successAddToWatchList = 1
    case failToAdd = -1
}

class AddMediaToWatchListService: Service {
    func execute(in dispatcher: Dispatcher, completionHandler: @escaping (AddMediaToWatchListStatusCode) -> (), failureBlock: @escaping (Int?) -> ()) {
        do {
            try dispatcher.execute(request: request, completionHandler: { (response) in
                switch response {
                case .json(let json):
                    let statusCode = json["status_code"].intValue
                    let mediaState = AddMediaToWatchListStatusCode(rawValue: statusCode)
                    
                    completionHandler(mediaState ?? .failToAdd)
                case .error(let errorCode, _):
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
    
    typealias output = AddMediaToWatchListStatusCode
    
    init(mediaType: String, mediaID: Int, watchList: Bool) {
        self.request = AccountRequest.addToWatchList(mediaType: mediaType, mediaId: mediaID, watchlist: watchList)
    }
}
