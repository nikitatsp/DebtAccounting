import Foundation

protocol DebtListInteractorInputProtocol {
    init(presenter: DebtListInteractorOutputProtocol, typeOfInteractor: ListType)
    func loadInitalData()
}

protocol DebtListInteractorOutputProtocol: AnyObject {
    func recieveInitalData(sectionsITo: [Section], sectionToMe: [Section])
}

final class DebtListInteractor: DebtListInteractorInputProtocol {
    
    let typeOfInteractor: ListType
    weak var presenter: DebtListInteractorOutputProtocol!
    let debtListService = DebtListService()
    
    init(presenter: DebtListInteractorOutputProtocol, typeOfInteractor: ListType) {
        self.presenter = presenter
        self.typeOfInteractor = typeOfInteractor
    }
    
    func loadInitalData() {
        let sectionsITo = debtListService.loadInitalDataITo(for: typeOfInteractor)
        let sectionsToMe = debtListService.loadInitalDataToMe(for: typeOfInteractor)
        presenter.recieveInitalData(sectionsITo: sectionsITo, sectionToMe: sectionsToMe)
    }
}
