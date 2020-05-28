//
//  GetFavouriteMovies.swift
//  MyMovies

import Foundation
import SwiftyJSON

class GetFavouriteMoviesService: Service {
    typealias output = [Movie]
    
    var request: Request {
        return AccountRequest.getFavouriteMovies
    }
    
    func execute(in dispatcher: Dispatcher, completionHandler: @escaping ([Movie]) -> (), failureBlock: @escaping (Int?) -> ()) {
        do {
            try dispatcher.execute(request: request, completionHandler: { (response) in
                switch response {
                case .json(let json):
                    let resultJSON = json["results"]
                    
                    var movies = [Movie]()
                    
                    for (_, subJson) in resultJSON {
                        let movie = Movie(json: subJson)
                        
                        movies.append(movie)
                    }
                    
                    completionHandler(movies)
                    
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
    
}
