import UIKit
import CoreData

final class ActiveProfile {
    static let shared = ActiveProfile()
    private init() {}
    
    let context = CoreDataService.shared.getContext()
    
    let didChangeActiveIToArr = NSNotification.Name("didChangeActiveIToArr")
    let didChangeActiveToMeArr = NSNotification.Name("didChangeActiveToMeArr")
    
    lazy var activeIToArr: [Section] = {
        let fetchRequest: NSFetchRequest<Section> = Section.fetchRequest()
        var arr: [Section] = []
        do {
            arr = try context.fetch(fetchRequest)
            return arr
        } catch {
            print(error.localizedDescription)
            return []
        }
    }()
    
    var activeToMeArr: [Section] = []
}
