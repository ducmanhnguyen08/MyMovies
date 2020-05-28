//
//  GetVideoOfMovieService.swift
//  MyMovies
//
import Foundation
import SwiftyJSON

class GetVideoOfMovieService: Service {
    var request: Request
    
    func execute(in dispatcher: Dispatcher, completionHandler: @escaping ([Video]) -> (), failureBlock: @escaping (Int?) -> ()) {
        do {
            try dispatcher.execute(request: request, completionHandler: { (response) in
                switch response {
                case .json(let json):
                    
                    let resultJSON = json["results"]
                    var videos = [Video]()
                    
                    for (_, subJson) in resultJSON {
                        let video = Video(json: subJson)
                        videos.append(video)
                    }
                    
                    completionHandler(videos)
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
    
    
    typealias output = [Video]
    
    
    init(id: String) {
        self.request = MovieRequest.videoOfMovieWithID(id: id)
    }
}
