//
//  Video.swift
//  MyMovies

import Foundation
import SwiftyJSON

class Video: NSObject {
    let id: String
    let key: String
    let name: String
    var thumnailUrl: String
    
    init(json: JSON) {
        self.id = json["id"].stringValue
        self.key = json["key"].stringValue
        self.name = json["name"].stringValue
        self.thumnailUrl = "https://img.youtube.com/vi/\(json["key"].stringValue)/hqdefault.jpg"
    }
}
