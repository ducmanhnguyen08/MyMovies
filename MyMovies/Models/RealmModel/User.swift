//
//  User.swift
//  MyMovies

import Foundation
import RealmSwift

enum UserSessionType: Int {
    case imbdUser = 0
    case guestUser = 1
    case notDefined = -1
}

public class User: Object {
    @objc dynamic var userType: Int = UserSessionType.notDefined.rawValue
    @objc dynamic var sessionId: String = ""
    @objc dynamic var username: String = ""
    
    var sessionType: UserSessionType {
        get {
            return UserSessionType(rawValue: userType)!
        }
        
        set {
            self.userType = newValue.rawValue
        }
    }
}
