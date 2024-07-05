import UIKit
import CoreData

final class HistoryProfile {
    static let shared = HistoryProfile()
    private init() {}
    
    private let context = CoreDataService.shared.getContext()
    
    let didChangeHistoryIToArr = NSNotification.Name("didChangeHistoryIToArr")
    let didChangeHistoryToMeArr = NSNotification.Name("didChangeHistoryToMeArr")
    
    lazy var histIToArr: [Section] = {
        let fetchRequest: NSFetchRequest<Section> = Section.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isToMe == %d AND isHist == %d", false, true)
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
    
    lazy var histToMeArr: [Section] = {
        let fetchRequest: NSFetchRequest<Section> = Section.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isToMe == %d AND isHist == %d", true, true)
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

