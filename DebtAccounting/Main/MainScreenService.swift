import Foundation
import CoreData

final class MainScreenService {
    static let shared = MainScreenService()
    private init() {}
    
    private let context = CoreDataService.shared.getContext()
    
    func loadSumI() -> Sum? {
        let fetchRequest: NSFetchRequest<Sum> = Sum.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isI == %d", true)
        do {
            let sumItoArr = try context.fetch(fetchRequest)
            
            if let sumITo = sumItoArr.first {
                return sumITo
            } else {
                let sumITo = Sum(context: context)
                sumITo.isI = true
                
                do {
                    try context.save()
                    return sumITo
                } catch {
                    print(error.localizedDescription)
                    return nil
                }
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func loadSumToMe() -> Sum? {
        let fetchRequest: NSFetchRequest<Sum> = Sum.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isI == %d", false)
        do {
            let sumToMeArr = try context.fetch(fetchRequest)
            
            if let sumToMe = sumToMeArr.first {
                return sumToMe
            } else {
                let sumToMe = Sum(context: context)
                sumToMe.isI = false
                
                do {
                    try context.save()
                    return sumToMe
                } catch {
                    print(error.localizedDescription)
                    return nil
                }
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
