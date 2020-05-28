//
//  GetCurrentUserDetailService.swift
//  MyMovies


import Foundation
import SwiftyJSON

class GetCurrentUserDetailService: Service {
    var request: Request {
        return AccountRequest.getAccountDetail
    }
    
    func execute(in dispatcher: Dispatcher, completionHandler: @escaping (String) -> (), failureBlock: @escaping (Int?) -> ()) {
        do {
            try dispatcher.execute(request: request, completionHandler: { (response) in
                switch response {
                case .json(let json):
                    let username = json["username"].stringValue
                    
                    completionHandler(username)
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
    
    typealias output = String
    
    
}
