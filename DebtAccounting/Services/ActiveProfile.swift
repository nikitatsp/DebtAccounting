import UIKit

final class ActiveProfile {
    static let shared = ActiveProfile()
    private init() {}
    
    let didChangeActiveIToArr = NSNotification.Name("didChangeActiveIToArr")
    let didChangeActiveToMeArr = NSNotification.Name("didChangeActiveToMeArr")
    
    var activeIToArr: [Section] = []
    var activeToMeArr: [Section] = []
}
