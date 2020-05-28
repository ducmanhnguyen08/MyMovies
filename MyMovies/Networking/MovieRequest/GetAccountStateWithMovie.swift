//
//  GetAccountStateWithMovie.swift
//  MyMovies

import Foundation
import SwiftyJSON

class GetAccountStateWithMovie: Service {
    var request: Request
    
    func execute(in dispatcher: Dispatcher, completionHandler: @escaping (MovieUserState) -> (), failureBlock: @escaping (Int?) -> ()) {
        do {
            try dispatcher.execute(request: request, completionHandler: { (response) in
                switch response {
                case .json(let json):
                    
                    if let rating = json["rated"]["value"].double {
                        let userState = MovieUserState(rating: rating, isFavourite: json["favorite"].boolValue, isWatchList: json["watchlist"].boolValue)
                        completionHandler(userState)
                    } else {
                        let userState = MovieUserState(rating: nil, isFavourite: json["favorite"].boolValue, isWatchList: json["watchlist"].boolValue)
                        completionHandler(userState)
                    }
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
    
    typealias output = MovieUserState
    
    init(id: String) {
        self.request = MovieRequest.accountStateOfMovie(id: id)
    }
}
