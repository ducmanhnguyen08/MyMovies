//
//  GetMovieWithIDService.swift
//  MyMovies


import Foundation
import SwiftyJSON

class GetMovieWithIDService: Service {
    var request: Request
    
    func execute(in dispatcher: Dispatcher, completionHandler: @escaping (Movie) -> (), failureBlock: @escaping (Int?) -> ()) {
        do {
            try dispatcher.execute(request: request, completionHandler: { (response) in
                switch response {
                case .json(let json):
                    
                    let movie = Movie(json: json)
                    movie.runtime = json["runtime"].intValue
                    let genresJSON = json["genres"]
                    var movieType = ""
                    for (key, subJson) in genresJSON {
                        
                        if Int(key) == 0 {
                            movieType = movieType + "\(subJson["name"].stringValue)"
                        } else {
                            movieType = movieType + ", \(subJson["name"].stringValue)"
                        }
                    }
                    movie.movieType = movieType
                    
                    completionHandler(movie)
                    
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
    
    typealias output = Movie
    
    init(id: String) {
        self.request = MovieRequest.movieWithID(id: id)
    }
    
}
