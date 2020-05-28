//
//  Movie.swift
//  MyMovies

import Foundation
import SwiftyJSON

public class Movie: NSObject {
    let vote_count: Int
    let id: Int
    let video: Bool
    let vote_average: Float
    let title: String
    let poster_path: String
    let backdrop_path: String
    let overview: String
    let release_date: String
    var runtime: Int?
    var movieType: String?
    var yearOfRelease: String?
    var rating: Double?
    var isFavourite: Bool?
    var isInWatchList: Bool?
    
    init(json: JSON) {
        self.vote_count = json["vote_count"].intValue
        self.id = json["id"].intValue
        self.video = json["video"].boolValue
        self.vote_average = json["vote_average"].floatValue
        self.title = json["title"].stringValue
        self.poster_path = "https://image.tmdb.org/t/p/w500" + json["poster_path"].stringValue
        self.backdrop_path = "https://image.tmdb.org/t/p/w500" + json["backdrop_path"].stringValue
        self.overview = json["overview"].stringValue
        self.release_date = json["release_date"].stringValue
    }
    
}
