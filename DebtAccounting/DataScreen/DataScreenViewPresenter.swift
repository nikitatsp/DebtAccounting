import UIKit

protocol DataScreenViewControllerDelegate: AnyObject {
    func didTapBackButton()
    func didTapCreateSaveBarButton(model: Debt)
}

struct StateOfDataScreen {
    var isI: Bool
    var isActive: Bool
    var debt: Debt?
    weak var delegate: DataScreenViewControllerDelegate!
}

final class DataScreenViewPresenter: DataScreenViewControllerOutputProtocol {
    weak var view: DataScreenViewControllerInputProtocol!
    var interactor: DataScreenInteractorInputProtocol!
    var stateOfDataScreen: StateOfDataScreen
    
    init(view: DataScreenViewControllerInputProtocol, isI: Bool, isActive: Bool, debt: Debt?, delegate: DataScreenViewControllerDelegate) {
        self.view = view
        self.stateOfDataScreen = StateOfDataScreen(isI: isI, isActive: isActive, debt: debt, delegate: delegate)
    }
    
    func viewDidLoad() {
        if stateOfDataScreen.isI {
            view.setTextInNameLabel(text: "Кому")
        } else {
            view.setTextInNameLabel(text: "Должник")
        }
        
        if let debt = stateOfDataScreen.debt {
            view.fillDataScreen(date: debt.date, purshase: debt.purshase, name: debt.name, sum: debt.sum, telegram: debt.telegram, phone: debt.phone)
        }
    }
    
    func didTapBackButton() {
        stateOfDataScreen.delegate.didTapBackButton()
    }
    
    func didTapSaveButton(date: Date, purshase: String?, name: String?, sum: String?, telegram: String?, phone: String?) {
        interactor.makeNewDebt(date: date, purshase: purshase, name: name, sum: sum, telegram: telegram, phone: phone, isI: stateOfDataScreen.isI, isActive: stateOfDataScreen.isActive)
    }
    
    func textFieldDidChange(purshaseText: String?, nameText: String?, sumText: String?) {
        let isPurshaseFieldFilled = !(purshaseText?.isEmpty ?? true)
        let isNameFieldFilled = !(nameText?.isEmpty ?? true)
        let isSumFieldFilled = !(sumText?.isEmpty ?? true)
        let isSaveButtonEnabled = isNameFieldFilled && isSumFieldFilled && isPurshaseFieldFilled
        view?.updateSaveButton(isEnabled: isSaveButtonEnabled)
    }
}

//MARK: - DataScreenInteractorOutputProtocol

extension DataScreenViewPresenter: DataScreenInteractorOutputProtocol {
    
}
