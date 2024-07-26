import Foundation

//MARK: - Protocols

protocol DataScreenInteractorInputProtocol {
    init(presenter: DataScreenInteractorOutputProtocol)
    func makeNewDebt(date: Date, purshase: String?, name: String?, sum: String?, telegram: String?, phone: String?, isI: Bool, isActive: Bool)
    func editDebt(debt: Debt, date: Date, purshase: String?, name: String?, sum: String?, telegram: String?, phone: String?, isI: Bool, isActive: Bool)
}

protocol DataScreenInteractorOutputProtocol: AnyObject {
    func didRecieveNewDebt(debt: Debt)
    func didRecieveEditedDebt(debt: Debt, lastSum: Int64)
}

//MARK: - DataScreenInteractorInputProtocol

final class DataScreenInteractor: DataScreenInteractorInputProtocol {
    weak var presenter: DataScreenInteractorOutputProtocol!
    
    init(presenter: DataScreenInteractorOutputProtocol) {
        self.presenter = presenter
    }
    
    private let dataScreenService = DataScreenService.shared
    private let coreDataService = CoreDataService.shared
    
    func makeNewDebt(date: Date, purshase: String?, name: String?, sum: String?, telegram: String?, phone: String?, isI: Bool, isActive: Bool) {
        let debt = dataScreenService.createNewDebt(date: date, purshase: purshase, name: name, sum: Int64(sum!)!, telegram: telegram, phone: phone, isI: isI, isActive: isActive)
        coreDataService.saveContextWith { [weak self] in
            self?.presenter.didRecieveNewDebt(debt: debt)
        }
    }
    
    func editDebt(debt: Debt, date: Date, purshase: String?, name: String?, sum: String?, telegram: String?, phone: String?, isI: Bool, isActive: Bool) {
        let lastSum = debt.sum
        debt.date = date
        debt.purshase = purshase
        debt.name = name
        debt.sum = Int64(sum!)!
        debt.telegram = telegram
        debt.phone = phone
        debt.isI = isI
        debt.isActive = isActive
        coreDataService.saveContextWith { [weak self] in
            self?.presenter.didRecieveEditedDebt(debt: debt, lastSum: lastSum)
        }
    }
}
