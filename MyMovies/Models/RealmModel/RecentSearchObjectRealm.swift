

import Foundation
import RealmSwift

enum MediaType: Int {
    case notdefined = -1
    case movie = 0
    case tvShow = 1
}

public class RecentSearchObjectRealm: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var voteCount: Int = -1
    @objc dynamic var posterPath: String = ""
    @objc dynamic var id: Int = -1
    @objc dynamic var media = MediaType.notdefined.rawValue
    
    var mediaType: MediaType {
        get {
            return MediaType(rawValue: media)!
        }
        
        set {
            media = newValue.rawValue
        }
    }
}
