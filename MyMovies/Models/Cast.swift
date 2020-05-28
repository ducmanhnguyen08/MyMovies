//
//  Cast.swift
//  MyMovies

import Foundation
import SwiftyJSON

class Cast: NSObject {
    let profile_path: String
    let name: String
    let character: String
    let id: Int
    
    init(json: JSON) {
        self.profile_path = "https://image.tmdb.org/t/p/w500" + json["profile_path"].stringValue
        self.name = json["name"].stringValue
        self.character = json["character"].stringValue
        self.id = json["id"].intValue
    }
}
