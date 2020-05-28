//
//  Season.swift
//  MyMovies


import Foundation
import SwiftyJSON

public class Season: NSObject {
    let id: Int
    let name: String
    let episode_count: Int
    let air_date: String
    let overview: String
    let poster_path: String
    let seasonNumber: Int
    var episodes: [Episode]?
    
    init(json: JSON) {
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.episode_count = json["episode_count"].intValue
        self.air_date = json["air_date"].stringValue
        self.overview = json["overview"].stringValue
        self.poster_path = "https://image.tmdb.org/t/p/w780" + json["poster_path"].stringValue
        self.seasonNumber = json["season_number"].intValue
    }
}
