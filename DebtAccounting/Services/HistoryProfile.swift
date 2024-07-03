import UIKit

final class HistoryProfile {
    static let shared = HistoryProfile()
    private init() {}
    
    let didChangeHistoryIToArr = NSNotification.Name("didChangeHistoryIToArr")
    let didChangeHistoryToMeArr = NSNotification.Name("didChangeHistoryToMeArr")
    
    var histIToArr: [Section] = []
    var histToMeArr: [Section] = []
}

