import Foundation

struct Notifications {
    static let shared = Notifications()
    private init() {}
    
    let sumIDidChange = NSNotification.Name("sumIDidChange")
    let sumToMeDidChange = NSNotification.Name("sumToMeDidChange")
    
    let sectionsIToActiveDidChange = NSNotification.Name("sectionsIToActiveDidChange")
    let sectionsToMeActiveDidChange = NSNotification.Name("sectionsToMeActiveDidChange")
    
    let sectionsIToHistoryDidChange = NSNotification.Name("sectionsIToHistoryDidChange")
    let sectionsToMeHistoryDidChange = NSNotification.Name("sectionsToMeHistoryDidChange")
}
