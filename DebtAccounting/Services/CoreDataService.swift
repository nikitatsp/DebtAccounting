import UIKit
import CoreData

final class CoreDataService {
    static let shared = CoreDataService()
    private init() {}
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func saveContextWith(completion: @escaping() -> Void) {
        do {
            let context = getContext()
            try context.save()
            completion()
        } catch {
            print(error.localizedDescription)
            return
        }
    }
    
    func deleteFromContex(object: NSManagedObject) {
        let context = getContext()
        context.delete(object)
    }
}
