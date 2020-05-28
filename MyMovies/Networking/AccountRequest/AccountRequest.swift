//
//  AccountRequest.swift
//  MyMovies


import Foundation

public enum AccountRequest: Request {
    
    case getMovieWatchList
    case getRatedMovies
    case getFavouriteMovies
    case addToWatchList(mediaType: String, mediaId: Int, watchlist: Bool)
    case addToFavourite(mediaType: String, mediaId: Int, favourite: Bool)
    case getAccountDetail
    
    public var path: String {
        switch self {
        case .getMovieWatchList:
            return "movies"
        case .addToWatchList(_, _, _):
            return "watchlist"
        case .getRatedMovies:
            return "rated/movies"
        case .addToFavourite(_, _, _):
            return "favorite"
        case .getFavouriteMovies:
            return "favorite/movies"
        case .getAccountDetail:
            return "account"
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .getMovieWatchList:
            return .get
        case .addToWatchList:
            return .post
        case .getRatedMovies:
            return .get
        case .addToFavourite:
            return .post
        case .getFavouriteMovies:
            return .get
        case .getAccountDetail:
            return .get
        }
    }
    
    public var parameters: RequestParams? {
        
        guard let currentSessionId = UserSessionController.shared.getCurrentUser()?.sessionId else { return nil }
        
        switch self {
        case .getMovieWatchList :
            return RequestParams.url(["api_key" : Constant.API_KEY, "session_id" : currentSessionId])
        case .addToWatchList(let mediaType, let media_id, let watchlist):
            return RequestParams.both(body: ["media_type" : mediaType, "media_id" : media_id, "watchlist" : watchlist], url: ["api_key" : Constant.API_KEY, "session_id" : currentSessionId])
        case .getRatedMovies:
            return RequestParams.url(["api_key" : Constant.API_KEY, "session_id" : currentSessionId, "sort_by" : "created_at.asc"])
        case .getFavouriteMovies:
            return RequestParams.url(["api_key" : Constant.API_KEY, "session_id" : currentSessionId, "sort_by" : "created_at.asc"])
        case .addToFavourite(let mediaType, let mediaId, let favourite):
            return RequestParams.both(body: ["media_type" : mediaType, "media_id" : mediaId, "favorite" : favourite], url: ["api_key" : Constant.API_KEY, "session_id" : currentSessionId])
        case .getAccountDetail:
            return RequestParams.url(["api_key" : Constant.API_KEY, "session_id" : currentSessionId])
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .addToWatchList:
            return ["Content-Type" : "application/json; charset=utf-8"]
        default:
            return nil
        }
    }
    
    public var dataType: DataType {
        switch self {
        default:
            return .JSON
        }
    }
    
    
}
