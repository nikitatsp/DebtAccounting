import UIKit

final class SumProfile {
    static let shared = SumProfile()
    private init() {}
    
    let didChangeSumITo = NSNotification.Name("didChangeSumITo")
    let didChangeSumToMe = NSNotification.Name("didChangeSumToMe")
    
    var sumITo: Int = 0
    var sumToMe: Int = 0
    
}
