//
//  Constant.swift
//  MyMovies

import Foundation
struct Constant {
    static let API_KEY: String = "71aae5ac0de6a3b943179fb75b5b8da0"
    static let MOVIE_HOSTNAME = "https://api.themoviedb.org/3/movie"
    static let USER_REQUEST_TOKEN = "da86c66cd737dd1823b275d5b77e54a513dd45ef"

    static let WATCHLIST_HOSTNAME = "https://api.themoviedb.org/3/account/{account_id}/watchlist"
    static let ACCOUNT_HOSTNAME = "https://api.themoviedb.org/3/account/{account_id}"
    static let ACCOUNT_DETAIL_HOSTNAME = "https://api.themoviedb.org/3"
    static let AUTHENTICATION_HOSTNAME = "https://api.themoviedb.org/3/authentication"
    
    static var shouldReloadFavouriteMovie = false {
        didSet {
            print(shouldReloadFavouriteMovie)
        }
    }
    
    static var shouldReloadWatchlistMovie = false {
        didSet {
            print(shouldReloadWatchlistMovie)
        }
    }
}
