import Foundation
import CoreData

protocol DataScreenInteractorInputProtocol {
    init(presenter: DataScreenInteractorOutputProtocol)
    func makeNewDebt(date: Date, purshase: String?, name: String?, sum: String?, telegram: String?, phone: String?, isI: Bool, isActive: Bool)
}

protocol DataScreenInteractorOutputProtocol: AnyObject {
    
}

final class DataScreenInteractor: DataScreenInteractorInputProtocol {
    let context = CoreDataService.shared.getContext()
    weak var presenter: DataScreenInteractorOutputProtocol!
    
    init(presenter: DataScreenInteractorOutputProtocol) {
        self.presenter = presenter
    }
    
    func makeNewDebt(date: Date, purshase: String?, name: String?, sum: String?, telegram: String?, phone: String?, isI: Bool, isActive: Bool) {
        let debt = Debt(context: context)
        debt.date = date
        debt.purshase = purshase
        debt.name = name
        debt.sum = Int64(sum!)!
        debt.telegram = telegram
        debt.phone = phone
        debt.isI = isI
        debt.isActive = isActive
    }
}
