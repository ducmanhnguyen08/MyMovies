//
//  RatingMovieService.swift
//  MyMovies
//

import Foundation
import SwiftyJSON

enum MovieRatingStatusCodeOption: Int {
    case successUpdate = 12
    case successRating = 1
    case failToRate = -1
}

class RatingMovieService: Service {
    
    var request: Request
    
    typealias output = MovieRatingStatusCodeOption
    
    init(id: String, rating: Double) {
        self.request = MovieRequest.rateAMovieWith(id: id, rating: rating)
    }
    
    func execute(in dispatcher: Dispatcher, completionHandler: @escaping (MovieRatingStatusCodeOption) -> (), failureBlock: @escaping (Int?) -> ()) {
        do {
            try dispatcher.execute(request: request) { (response) in
                switch response {
                case .json(let json):
                    print(json)
                case .error(let errorCode, _):
                    failureBlock(errorCode)
                default:
                    ()
                }
            }
        } catch let err {
            print(err.localizedDescription)
        }
    }
}
