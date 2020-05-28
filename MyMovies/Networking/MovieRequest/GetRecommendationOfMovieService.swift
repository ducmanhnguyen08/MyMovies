//
//  GetRecommendationOfMovieService.swift
//  MyMovies
//


import Foundation
import SwiftyJSON

class GetRecommendationOfMovie: Service {
    var request: Request
    
    func execute(in dispatcher: Dispatcher, completionHandler: @escaping ([Movie]) -> (), failureBlock: @escaping (Int?) -> ()) {
        do {
            try dispatcher.execute(request: request, completionHandler: { (response) in
                switch response {
                case .json(let json):
                    
                    let resultJson = json["results"]
                    var recommendationMovies = [Movie]()
                    for(key, subJson) in resultJson {
                        let movie = Movie(json: subJson)
                        recommendationMovies.append(movie)
                    }
                    completionHandler(recommendationMovies)
                    
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
    
    init(id: String) {
        self.request = MovieRequest.recommendationOfMovieWithID(id: id)
    }
}
