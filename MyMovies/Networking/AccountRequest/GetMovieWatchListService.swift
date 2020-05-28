//
//  GetMovieWatchListService.swift
//  MyMovies


import Foundation
import SwiftyJSON

class GetMovieWatchListService: Service {
    
    var request: Request {
        return AccountRequest.getMovieWatchList
    }
    
    typealias output = [Movie]
    
    func execute(in dispatcher: Dispatcher, completionHandler: @escaping ([Movie]) -> (), failureBlock: @escaping (Int?) -> ()) {
        do {
            try dispatcher.execute(request: request, completionHandler: { (response) in
                switch response {
                case .json(let json):
                    let resultJson = json["results"]
                    var movieWatchList = [Movie]()
                    for(key, subJson) in resultJson {
                        let movie = Movie(json: subJson)
                        movieWatchList.append(movie)
                    }
                    completionHandler(movieWatchList)
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
