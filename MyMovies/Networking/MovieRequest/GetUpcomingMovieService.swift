//
//  GetUpcomingMovieService.swift
//  MyMovies

import Foundation
import SwiftyJSON

class GetUpcomingMovieService: Service {
    func execute(in dispatcher: Dispatcher, completionHandler: @escaping ([Movie]) -> (), failureBlock: @escaping (Int?) -> ()) {
        do {
            try dispatcher.execute(request: request, completionHandler: { (response) in
                switch response {
                case .json(let json):
                    
                    let resultJson = json["results"]
                    var upComingMovies = [Movie]()
                    for(key, subJson) in resultJson {
                        let movie = Movie(json: subJson)
                        upComingMovies.append(movie)
                    }
                    completionHandler(upComingMovies)
                    
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
    
    var request: Request {
        return MovieRequest.upComing
    }
    
    typealias output = [Movie]
    
    
}
