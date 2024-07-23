import Foundation
import CoreData

final class DebtListService {
    
    static let shared = DebtListService()
    private let context = CoreDataService.shared.getContext()
    
    private init() {}
    
    func loadInitalDataITo(for isActive: Bool) -> [Section] {
        if isActive {
            let fetchRequest: NSFetchRequest<Section> = Section.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "isI == %d AND isActive == %d", true, true)
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
            var arr: [Section] = []
            do {
                arr = try context.fetch(fetchRequest)
                return arr
            } catch {
                print(error.localizedDescription)
                return []
            }
        } else {
            let fetchRequest: NSFetchRequest<Section> = Section.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "isI == %d AND isActive == %d", true, false)
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
    
    func loadInitalDataToMe(for isActive: Bool) -> [Section] {
        if isActive {
            let fetchRequest: NSFetchRequest<Section> = Section.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "isI == %d AND isActive == %d", false, true)
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
            var arr: [Section] = []
            do {
                arr = try context.fetch(fetchRequest)
                return arr
            } catch {
                print(error.localizedDescription)
                return []
            }
        } else {
            let fetchRequest: NSFetchRequest<Section> = Section.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "isI == %d AND isActive == %d", false, false)
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
    
    func createNewSection(with newDebt: Debt) -> Section {
        let section = Section(context: context)
        section.date = newDebt.date
        section.isActive = newDebt.isActive
        section.isI = newDebt.isI
        section.addToDebts(newDebt)
        return section
    }
    
    
}
