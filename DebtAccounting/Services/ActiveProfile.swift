import UIKit
import CoreData

final class ActiveProfile {
    static let shared = ActiveProfile()
    private init() {}
    
    private let context = CoreDataService.shared.getContext()
    
    let didChangeActiveIToArr = NSNotification.Name("didChangeActiveIToArr")
    let didChangeActiveToMeArr = NSNotification.Name("didChangeActiveToMeArr")
    
    lazy var activeIToArr: [Section] = {
        let fetchRequest: NSFetchRequest<Section> = Section.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isToMe == %d AND isHist == %d", false, false)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        var arr: [Section] = []
        do {
            arr = try context.fetch(fetchRequest)
            return arr
        } catch {
            print(error.localizedDescription)
            return []
        }
    }()
    
    lazy var activeToMeArr: [Section] = {
        let fetchRequest: NSFetchRequest<Section> = Section.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isToMe == %d AND isHist == %d", true, false)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        var arr: [Section] = []
        do {
            arr = try context.fetch(fetchRequest)
            return arr
        } catch {
            print(error.localizedDescription)
            return []
        }
    }()
}
