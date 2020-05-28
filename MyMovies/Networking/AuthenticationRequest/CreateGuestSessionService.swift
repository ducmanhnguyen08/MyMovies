//
//  CreateGuestSessionService.swift
//  MyMovies


import Foundation
import SwiftyJSON

class CreateGuestSessionService: Service {
    var request: Request {
        return AuthenticationRequest.createGuestSession
    }
    
    typealias output = String
    
    func execute(in dispatcher: Dispatcher, completionHandler: @escaping (String) -> (), failureBlock: @escaping (Int?) -> ()) {
        do {
            try dispatcher.execute(request: request, completionHandler: { (response) in
                switch response {
                case .json(let json):
                    let result = json["success"].boolValue
                    
                    if result {
                        let requestToken = json["guest_session_id"].stringValue
                        completionHandler(requestToken)
                    } else {
                        failureBlock(nil)
                    }
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
