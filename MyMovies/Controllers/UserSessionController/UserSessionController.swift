
import Foundation
import RealmSwift

enum UserState {
    case Undefined, Opened, Closed, Invalid
}

class UserSessionController {
    
    static let shared = UserSessionController()
    
    // MARK: Properties
    
    private(set) var state: UserState = .Undefined
    
    private let realm = try! Realm()
    
    private var user: User?
    
    init() {
        
    }
    
    func deleteCurrentUser() {
        
        // Delete only if session state is open
        state = .Closed
        
        self.user = nil
        
        let users = Array(realm.objects(User.self))
        
        try! realm.write {
            realm.delete(users)
        }
    }
    
    func updateCurrentUser(user: User) {
        self.user = user
        
        self.state = .Opened
        
        // Save user object with realm
        
        try! realm.write {
            realm.add(user)
        }
    }
    
    func getCurrentUser() -> User? {
        
        guard let currentUser = Array(realm.objects(User.self)).first else { return nil }
        
        return currentUser
    }
    
}




