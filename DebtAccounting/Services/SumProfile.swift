import UIKit
import CoreData

final class SumProfile {
    static let shared = SumProfile()
    private init() {}
    
    private let context = CoreDataService.shared.getContext()
    
    let didChangeSumITo = NSNotification.Name("didChangeSumITo")
    let didChangeSumToMe = NSNotification.Name("didChangeSumToMe")
    
    lazy var sumITo: Sum? = {
        let fetchRequest: NSFetchRequest<Sum> = Sum.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isToMe == %d", false)
        do {
            let sumItoArr = try context.fetch(fetchRequest)
            
            if let sumITo = sumItoArr.first {
                return sumITo
            } else {
                let sumITo = Sum(context: context)
                sumITo.isToMe = false
                
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
    }()
    
    lazy var sumToMe: Sum? = {
        let fetchRequest: NSFetchRequest<Sum> = Sum.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isToMe == %d", true)
        do {
            let sumToMeArr = try context.fetch(fetchRequest)
            
            if let sumToMe = sumToMeArr.first {
                return sumToMe
            } else {
                let sumToMe = Sum(context: context)
                sumToMe.isToMe = true
                
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
    }()
}
