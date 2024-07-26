import Foundation
import CoreData

final class DataScreenService {
    static let shared = DataScreenService()
    private init() {}
    
    private let context = CoreDataService.shared.getContext()
    
    func createNewDebt(date: Date, purshase: String?, name: String?, sum: Int64, telegram: String?, phone: String?, isI: Bool, isActive: Bool) -> Debt {
        let debt = Debt(context: context)
        debt.date = date
        debt.purshase = purshase
        debt.name = name
        debt.sum = sum
        debt.telegram = telegram
        debt.phone = phone
        debt.isI = isI
        debt.isActive = isActive
        return debt
    }
}
