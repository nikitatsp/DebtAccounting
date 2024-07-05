import UIKit
import CoreData

final class CoreDataService {
    static let shared = CoreDataService()
    private init() {}
    
    func getContext() -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
