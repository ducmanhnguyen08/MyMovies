//
//  AuthenticationRequest.swift
//  MyMovies

import Foundation

public enum AuthenticationRequest: Request {
    
    case createRequestToken
    case createSessionWithLogin(username: String, password: String, requestToken: String)
    case createGuestSession
    case createSession(requestToken: String)
    
    public var path: String {
        switch self {
        case .createRequestToken:
            return "token/new"
        case .createSessionWithLogin(_, _, _):
            return "token/validate_with_login"
        case .createGuestSession:
            return "guest_session/new"
        case .createSession(_):
            return "session/new"
        }
    }
    
    public var method: HTTPMethod {
        return .get
    }
    
    public var parameters: RequestParams? {
        switch self {
        case .createRequestToken:
            return RequestParams.url(["api_key" : Constant.API_KEY])
        case .createSessionWithLogin(let username, let password, let requestToken):
            return RequestParams.url(["api_key" : Constant.API_KEY, "username" : username, "password" : password, "request_token" : requestToken])
        case .createGuestSession:
            return RequestParams.url(["api_key" : Constant.API_KEY])
        case .createSession(let requestToken):
            return RequestParams.url(["api_key" : Constant.API_KEY, "request_token" : requestToken])
        }
    }
    
    public var headers: [String : String]? {
        return nil
    }
    
    public var dataType: DataType {
        return .JSON
    }
    
    
}
