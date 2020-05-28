//
//  CreateSessionService.swift
//  MyMovies
//
import Foundation
import SwiftyJSON

class CreateSessionService: Service {
    var request: Request
    
    func execute(in dispatcher: Dispatcher, completionHandler: @escaping (String) -> (), failureBlock: @escaping (Int?) -> ()) {
        do {
            try dispatcher.execute(request: request, completionHandler: { (response) in
                switch response {
                case .json(let json):
                    let success = json["success"].boolValue
                    
                    if success {
                        completionHandler(json["session_id"].stringValue)
                    }
                    
                case .error(let errorCode, _):
                    failureBlock(errorCode)
                default:
                    ()
                }
            })
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    typealias output = String
    
    init(requestToken: String) {
        self.request = AuthenticationRequest.createSession(requestToken: requestToken)
    }
    
}
