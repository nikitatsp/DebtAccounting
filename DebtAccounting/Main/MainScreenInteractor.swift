import Foundation

protocol MainScreenInteractorInputProtocol {
    init(presenter: MainScreenInteractorOutputProtocol)
    func loadInitalData()
    func toogleIsI(isI: Bool)
    func toogleIsRub(isRub: Bool)
    func updateSumI(sum: Sum, count: Int64)
    func updateSumToMe(sum: Sum, count: Int64)
}

protocol MainScreenInteractorOutputProtocol: AnyObject {
    func sumIDidChange(sum: Sum)
    func sumToMeDidChange(sum: Sum)
    func isIDidChange(isI: Bool)
    func isRubDidChange(isRub: Bool)
}

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
        presenter.sumIDidChange(sum: sumI)
        presenter.sumToMeDidChange(sum: sumToMe)
    }
    
    func toogleIsI(isI: Bool) {
        let newIsI = !isI
        presenter.isIDidChange(isI: newIsI)
    }
    
    func toogleIsRub(isRub: Bool) {
        let newIsRub = !isRub
        presenter.isRubDidChange(isRub: newIsRub)
    }
    
    func updateSumI(sum: Sum, count: Int64) {
        sum.sum += count
        coreDataService.saveContextWith { [weak self] in
            self?.presenter.sumIDidChange(sum: sum)
        }
    }
    
    func updateSumToMe(sum: Sum, count: Int64) {
        sum.sum += count
        coreDataService.saveContextWith { [weak self] in
            self?.presenter.sumToMeDidChange(sum: sum)
        }
    }
}
