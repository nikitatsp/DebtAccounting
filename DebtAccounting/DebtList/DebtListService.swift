import Foundation
import CoreData

final class DebtListService {
    
    private let context = CoreDataService.shared.getContext()
    
    func loadInitalDataITo(for typeOfInteractor: ListType) -> [Section] {
        switch typeOfInteractor {
        case .active:
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
        case .history:
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
        }
    }
    
    func loadInitalDataToMe(for typeOfInteractor: ListType) -> [Section] {
        switch typeOfInteractor {
        case .active:
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
        case .history:
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
        }
    }
}
