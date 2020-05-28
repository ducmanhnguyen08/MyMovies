//
//  Episode.swift
//  MyMovies

import Foundation
import SwiftyJSON

class Episode: NSObject {
    let air_date: String
    let episode_number: Int
    let name: String
    let overview: String
    let id: Int
    let still_path: String
    let vote_average: Int
    
    init(json: JSON) {
        self.air_date = json["air_date"].stringValue
        self.episode_number = json["episode_number"].intValue
        self.name = json["name"].stringValue
        self.overview = json["overview"].stringValue
        self.id = json["id"].intValue
        self.still_path = "https://image.tmdb.org/t/p/w500" + json["still_path"].stringValue
        self.vote_average = json["vote_average"].intValue
    }
}
