//
//  Response.swift
//  MyMovies


import Foundation
import SwiftyJSON

public enum Response {
    case json(_: JSON)
    case data(_: Data)
    case error(_: Int?, _: Error?)
    
    init(_ response: (r: HTTPURLResponse?, data: Data?, error: Error?), for request: Request) {
        guard 200...299 ~= Int(response.r!.statusCode), response.error == nil else {
            self = .error(response.r?.statusCode, response.error)
            return
        }
        
        guard let data = response.data else {
            self = .error(response.r?.statusCode, NetworkErrors.noData)
            return
        }
        
        
        switch request.dataType {
        case .Data:
            self = .data(data)
        case .JSON:
            self = .json( try! JSON(data: data))
        }
    }
}
