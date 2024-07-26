import Foundation

//MARK: - Protocols

protocol MainScreenInteractorInputProtocol {
    init(presenter: MainScreenInteractorOutputProtocol)
    func loadInitalData()
    func toogleIsI(isI: Bool)
    func toogleIsRub(isRub: Bool)
    func updateSumI(sum: Sum, count: Int64)
    func updateSumToMe(sum: Sum, count: Int64)
}

protocol MainScreenInteractorOutputProtocol: AnyObject {
    func sumIDidChange(newSum: Sum)
    func sumToMeDidChange(newSum: Sum)
    func isIDidChange(newIsI: Bool)
    func isRubDidChange(newIsRub: Bool)
}

//MARK: - MainScreenInteractorInputProtocol

final class MainScreenInteractor: MainScreenInteractorInputProtocol {
    weak var presenter: MainScreenInteractorOutputProtocol!
    
    init(presenter: MainScreenInteractorOutputProtocol) {
        self.presenter = presenter
    }
    
    private let mainScreenService = MainScreenService.shared
    private let coreDataService = CoreDataService.shared
    
    func loadInitalData() {
        guard let sumI = mainScreenService.loadSumI() else {
            print("MainScreenInteractor/loadInitalData: sumI is nil")
            return
        }
        guard let sumToMe = mainScreenService.loadSumToMe() else {
            print("MainScreenInteractor/loadInitalData: sumToMe is nil")
            return
        }
        presenter.sumIDidChange(newSum: sumI)
        presenter.sumToMeDidChange(newSum: sumToMe)
    }
    
    func toogleIsI(isI: Bool) {
        let newIsI = !isI
        presenter.isIDidChange(newIsI: newIsI)
    }
    
    func toogleIsRub(isRub: Bool) {
        let newIsRub = !isRub
        presenter.isRubDidChange(newIsRub: newIsRub)
    }
    
    func updateSumI(sum: Sum, count: Int64) {
        sum.sum += count
        coreDataService.saveContextWith { [weak self] in
            self?.presenter.sumIDidChange(newSum: sum)
        }
    }
    
    func updateSumToMe(sum: Sum, count: Int64) {
        sum.sum += count
        coreDataService.saveContextWith { [weak self] in
            self?.presenter.sumToMeDidChange(newSum: sum)
        }
    }
}
