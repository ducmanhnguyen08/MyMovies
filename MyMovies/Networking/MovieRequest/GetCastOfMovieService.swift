//
//  GetCastOfMovieService.swift
//  MyMovies
//

import Foundation
import SwiftyJSON

class GetCastOfMovieService: Service {
    var request: Request
    
    func execute(in dispatcher: Dispatcher, completionHandler: @escaping ([Cast]) -> (), failureBlock: @escaping (Int?) -> ()) {
        do {
            try dispatcher.execute(request: request, completionHandler: { (response) in
                switch response {
                case .json(let json):
                    
                    let resultJSON = json["cast"]
                    var casts = [Cast]()
                    
                    for (_, subJson) in resultJSON {
                        let cast = Cast(json: subJson)
                        casts.append(cast)
                    }
                    
                    completionHandler(casts)
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
    
    typealias output = [Cast]
    
    init(id: String) {
        self.request = MovieRequest.castOfMovieWithID(id: id)
    }
    
}
