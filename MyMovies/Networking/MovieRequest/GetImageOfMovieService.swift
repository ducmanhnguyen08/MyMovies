//
//  GetImageOfMovieService.swift
//  MyMovies

import Foundation
import SwiftyJSON

class GetImageOfMovieService: Service {
    var request: Request
    
    func execute(in dispatcher: Dispatcher, completionHandler: @escaping ([Image]) -> (), failureBlock: @escaping (Int?) -> ()) {
        do {
            try dispatcher.execute(request: request, completionHandler: { (response) in
                switch response {
                case .json(let json):
                    
                    let resultJSON = json["backdrops"]
                    var images = [Image]()
                    
                    for (_, subJson) in resultJSON {
                        let image = Image(json: subJson)
                        images.append(image)
                    }
                    
                    completionHandler(images)
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
    
    typealias output = [Image]
    
    init(id: String) {
        self.request = MovieRequest.imageOfMovieWithID(id: id)
    }
}
