import Foundation

//MARK: - MainScreenModel

struct MainScreenModel {
    var isI: Bool = true
    var sumI: Sum!
    var sumToMe: Sum!
    var isRub = true
    var conversionRate: Double = ConversionRateService.shared.conversionRate?.rate ?? 0
}

//MARK: - MainScreenViewControllerOutputProtocol

final class MainScreenViewPresenter: MainScreenViewControllerOutputProtocol {
    weak var view: MainScreenViewControllerInputProtocol!
    var interactor: MainScreenInteractorInputProtocol!
    
    init(view: MainScreenViewControllerInputProtocol) {
        self.view = view
        self.mainScreenModel = MainScreenModel()
    }
    
    private let conversionRateService = ConversionRateService.shared
    private let notifications = Notifications.shared
    private let helper = MainScreenViewPresenterHelper.shared
    private var mainScreenModel: MainScreenModel
    
    func viewDidLoad() {
        interactor.loadInitalData()
        addObserver()
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(forName: notifications.sumIDidChange, object: nil, queue: .main) { [weak self] notification in
            guard let self else {return}
            self.actionForNotification(notification: notification, isI: true)
        }
        
        NotificationCenter.default.addObserver(forName: notifications.sumToMeDidChange, object: nil, queue: .main) { [weak self] notification in
            guard let self else {return}
            self.actionForNotification(notification: notification, isI: false)
        }
    }
    
    func segmentedControlValueChanged() {
        interactor.toogleIsI(isI: mainScreenModel.isI)
    }
    
    func didCurrencyBarButtonTapped() {
        interactor.toogleIsRub(isRub: mainScreenModel.isRub)
    }
}

//MARK: - MainScreenInteractorOutputProtocol

extension MainScreenViewPresenter: MainScreenInteractorOutputProtocol {
    func sumIDidChange(newSum: Sum) {
        mainScreenModel.sumI = newSum
        if mainScreenModel.isI {
            view.updateSumLabel(text: helper.textForShowInSumLabel(isI: mainScreenModel.isI, isRub: mainScreenModel.isRub, conversionRate: mainScreenModel.conversionRate, mainScreenModel: mainScreenModel))
        }
    }
    
    func sumToMeDidChange(newSum: Sum) {
        mainScreenModel.sumToMe = newSum
        if !mainScreenModel.isI {
            view.updateSumLabel(text: helper.textForShowInSumLabel(isI: mainScreenModel.isI, isRub: mainScreenModel.isRub, conversionRate: mainScreenModel.conversionRate, mainScreenModel: mainScreenModel))
        }
    }
    
    func isIDidChange(newIsI: Bool) {
        mainScreenModel.isI = newIsI
        view.updateSumLabel(text: helper.textForShowInSumLabel(isI: mainScreenModel.isI, isRub: mainScreenModel.isRub, conversionRate: mainScreenModel.conversionRate, mainScreenModel: mainScreenModel))
    }
    
    func isRubDidChange(newIsRub: Bool) {
        mainScreenModel.isRub = newIsRub
        if mainScreenModel.isRub {
            view.setImageForCurrencyButton(with: "rublesign")
        } else {
            view.setImageForCurrencyButton(with: "dollarsign")
        }
        view.updateSumLabel(text: helper.textForShowInSumLabel(isI: mainScreenModel.isI, isRub: mainScreenModel.isRub, conversionRate: mainScreenModel.conversionRate, mainScreenModel: mainScreenModel))
    }
}

//MARK: - Utilities

extension MainScreenViewPresenter {
    private func actionForNotification(notification: Notification, isI: Bool) {
        guard let userInfo = notification.userInfo else {
            print("MainScreenInteractor/addObserverForSumI: userInfo is nil")
            return
        }
        guard let newSum = userInfo["newSum"] as? Int64 else {
            print("MainScreenInteractor/addObserverForSumI: sumI is nil")
            return
        }
        
        if isI {
            interactor.updateSumI(sum: mainScreenModel.sumI, count: newSum)
        } else {
            interactor.updateSumToMe(sum: mainScreenModel.sumToMe, count: newSum)
        }
    }
}
