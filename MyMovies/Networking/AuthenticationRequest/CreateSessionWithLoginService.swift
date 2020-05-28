//
//  CreateSessionWithLoginService.swift
//  MyMovies


import Foundation
import SwiftyJSON

class CreateSessionWithLoginService: Service {
    var request: Request
    
    typealias output = String
    
    init(username: String, password: String, requestToken: String) {
        self.request = AuthenticationRequest.createSessionWithLogin(username: username, password: password, requestToken: requestToken)
    }
    
    func execute(in dispatcher: Dispatcher, completionHandler: @escaping (String) -> (), failureBlock: @escaping (Int?) -> ()) {
        do {
            try dispatcher.execute(request: request, completionHandler: { (response) in
                switch response {
                case .json(let json):
                    let result = json["success"].boolValue
                    
                    if result {
                        let requestToken = json["request_token"].stringValue
                        completionHandler(requestToken)
                    } else {
                        let statusCode = json["status_code"].intValue
                        failureBlock(statusCode)
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
