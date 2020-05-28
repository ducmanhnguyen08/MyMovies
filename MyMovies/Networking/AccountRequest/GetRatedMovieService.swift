//
//  GetRatedMovieService.swift
//  MyMovies

import Foundation
import SwiftyJSON

class GetRatedMovieService: Service {
    var request: Request {
        return AccountRequest.getRatedMovies
    }
    
    func execute(in dispatcher: Dispatcher, completionHandler: @escaping ([Movie]) -> (), failureBlock: @escaping (Int?) -> ()) {
        do {
            try dispatcher.execute(request: request, completionHandler: { (response) in
                switch response {
                case .json(let json):
                    let resultJson = json["results"]
                    var ratingMovieList = [Movie]()
                    for(key, subJson) in resultJson {
                        let movie = Movie(json: subJson)
                        movie.rating = subJson["rating"].doubleValue
                        ratingMovieList.append(movie)
                    }
                    completionHandler(ratingMovieList)
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
    
    typealias output = [Movie]
    
    
}
