//
//  DeleteMovieRating.swift
//  MyMovies


import Foundation
import SwiftyJSON

enum DeleteMediaStatusCode: Int {
    case success = 13
    case fail = -1
}

class DeleteMovieRatingService: Service {
    
    var request: Request
    
    func execute(in dispatcher: Dispatcher, completionHandler: @escaping (DeleteMediaStatusCode) -> (), failureBlock: @escaping (Int?) -> ()) {
        do {
            try dispatcher.execute(request: request, completionHandler: { (response) in
                switch response {
                case .json(let json):
                    let statusCode = json["status_code"].intValue
                    
                    if statusCode == 13 {
                        completionHandler(.success)
                    }
                    
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
    
    
    typealias output = DeleteMediaStatusCode
    
    init(id: String) {
        self.request = MovieRequest.deleteRatingOfMovie(id: id)
    }
}
