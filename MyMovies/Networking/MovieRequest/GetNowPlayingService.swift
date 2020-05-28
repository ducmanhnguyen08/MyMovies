//
//  GetNowPlayingService.swift
//  MyMovies


import Foundation
import SwiftyJSON

class GetNowPlayingMovieService: Service {
    var request: Request {
        return MovieRequest.nowPlaying
    }
    
    func execute(in dispatcher: Dispatcher, completionHandler: @escaping ([Movie]) -> (), failureBlock: @escaping (Int?) -> ()) {
        do {
            try dispatcher.execute(request: request, completionHandler: { (response) in
                switch response {
                case .json(let json):
                    let resultJson = json["results"]
                    var nowPlayingMovies = [Movie]()
                    for(key, subJson) in resultJson {
                        let movie = Movie(json: subJson)
                        nowPlayingMovies.append(movie)
                    }
                    completionHandler(nowPlayingMovies)
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
