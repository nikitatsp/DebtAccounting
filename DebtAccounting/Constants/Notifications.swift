import Foundation

struct Notifications {
    static let shared = Notifications()
    private init() {}
    
    let sumIDidChange = NSNotification.Name("sumIDidChange")
    let sumToMeDidChange = NSNotification.Name("sumToMeDidChange")
}
