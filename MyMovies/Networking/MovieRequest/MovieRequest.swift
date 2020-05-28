//
//  MovieRequest.swift
//  MyMovies


import Foundation

public enum MovieRequest: Request {
    
    case topRated
    case upComing
    case nowPlaying
    case popular
    case movieWithID(id: String)
    case videoOfMovieWithID(id: String)
    case imageOfMovieWithID(id: String)
    case castOfMovieWithID(id: String)
    case recommendationOfMovieWithID(id: String)
    case rateAMovieWith(id: String, rating: Double)
    case accountStateOfMovie(id: String)
    case deleteRatingOfMovie(id: String)
    
    public var path: String {
        switch self {
        case .topRated:
            return "top_rated"
        case .upComing:
            return "upcoming"
        case .nowPlaying:
            return "now_playing"
        case .popular:
            return "popular"
        case .movieWithID(let id):
            return "\(id)"
        case .videoOfMovieWithID(let id):
            return "\(id)/videos"
        case .imageOfMovieWithID(let id):
            return "\(id)/images"
        case .castOfMovieWithID(let id):
            return "\(id)/credits"
        case .recommendationOfMovieWithID(let id):
            return "\(id)/recommendations"
        case .rateAMovieWith(let id, _):
            return "\(id)/rating"
        case .accountStateOfMovie(let id):
            return "\(id)/account_states"
        case .deleteRatingOfMovie(let id):
            return "\(id)/rating"
        }
    }
    
    public var method: HTTPMethod  {
        switch self {
        case .rateAMovieWith( _, _):
            return .post
        case .deleteRatingOfMovie(_):
            return .delete
        default:
            return .get
        }
    }
    
    public var parameters: RequestParams? {
        
        guard let currentSessionId = UserSessionController.shared.getCurrentUser()?.sessionId else { return nil }
        
        switch self {
        case .imageOfMovieWithID(_):
            return RequestParams.url(["api_key" : Constant.API_KEY, "include_image_language" : "en", "language" : "en-US"])
        case .rateAMovieWith(_ , let rating):
            return RequestParams.both(body: ["value": rating], url: ["api_key" : Constant.API_KEY, "session_id" : currentSessionId])
        case .accountStateOfMovie(_):
            return RequestParams.url(["api_key" : Constant.API_KEY, "session_id" : currentSessionId])
        case .deleteRatingOfMovie(_):
            return RequestParams.url(["api_key" : Constant.API_KEY, "session_id" : currentSessionId])
        default:
            return RequestParams.url(["api_key" : Constant.API_KEY])
        }
    }
    
    public var headers: [String : String]? {
        switch self {
        case .rateAMovieWith( _ , _):
            return ["Content-Type" : "application/x-www-form-urlencoded"]
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
