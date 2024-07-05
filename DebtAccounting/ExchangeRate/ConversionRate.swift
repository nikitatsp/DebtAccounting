import Foundation
import CoreData

final class ConversionRateService {
    static let shared = ConversionRateService()
    private init() {}
    
    let context = CoreDataService.shared.getContext()
    
    lazy var conversionRate: ConversionRate? = {
        let fetchRequest: NSFetchRequest<ConversionRate> = ConversionRate.fetchRequest()
        do {
            let conversionRateArr = try context.fetch(fetchRequest)
            
            if let conversionRate = conversionRateArr.first {
                return conversionRate
            } else {
                let conversionRate = ConversionRate(context: context)
                conversionRate.rate = 0.01
                do {
                    try context.save()
                    return conversionRate
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
