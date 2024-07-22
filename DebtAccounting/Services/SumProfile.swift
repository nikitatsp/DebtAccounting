import UIKit
import CoreData

final class SumProfile {
    static let shared = SumProfile()
    private init() {}
    
    private let context = CoreDataService.shared.getContext()
    
    let didChangeSumITo = NSNotification.Name("didChangeSumITo")
    let didChangeSumToMe = NSNotification.Name("didChangeSumToMe")
    
   
}
