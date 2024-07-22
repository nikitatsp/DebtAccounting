import Foundation

struct MainScreenModel {
    var isI: Bool = true
    var sumI: Sum!
    var sumToMe: Sum!
    var isRub = true
    var conversionRate: Double = ConversionRateService.shared.conversionRate?.rate ?? 0
}

final class MainScreenViewPresenter: MainScreenViewControllerOutputProtocol {
    weak var view: MainScreenViewControllerInputProtocol!
    var interactor: MainScreenInteractorInputProtocol!
    
    init(view: MainScreenViewControllerInputProtocol) {
        self.view = view
        self.mainScreenModel = MainScreenModel()
    }
    
    private let conversionRateService = ConversionRateService.shared
    private let notifications = Notifications.shared
    private var mainScreenModel: MainScreenModel
    
    func viewDidLoad() {
        interactor.loadInitalData()
        addObserver()
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(forName: notifications.sumIDidChange, object: nil, queue: .main) { [weak self] notification in
            guard let self else {return}
            guard let userInfo = notification.userInfo else {
                print("MainScreenInteractor/addObserverForSumI: userInfo is nil")
                return
            }
            guard let sumI = userInfo["newSumI"] as? Int64 else {
                print("MainScreenInteractor/addObserverForSumI: sumI is nil")
                return
            }
            interactor.updateSumI(sum: mainScreenModel.sumI, count: sumI)
        }
        
        NotificationCenter.default.addObserver(forName: notifications.sumToMeDidChange, object: nil, queue: .main) { [weak self] notification in
            guard let self else {return}
            guard let userInfo = notification.userInfo else {
                print("MainScreenInteractor/addObserverForSumToMe: userInfo is nil")
                return
            }
            guard let sumToMe = userInfo["newSumToMe"] as? Int64 else {
                print("MainScreenInteractor/addObserverForSumToMe: sumToMe is nil")
                return
            }
            interactor.updateSumToMe(sum: mainScreenModel.sumToMe, count: sumToMe)
        }
    }
    
    func segmentedControlValueChanged() {
        mainScreenModel.isI.toggle()
        view.updateSumLabel(text: textForShowInSumLabel(isI: mainScreenModel.isI, isRub: mainScreenModel.isRub, conversionRate: mainScreenModel.conversionRate))
    }
    
    func didCurrencyBarButtonTapped() {
        mainScreenModel.isRub.toggle()
        if mainScreenModel.isRub {
            view.setImageForCurrencyButton(image: "rublesign")
        } else {
            view.setImageForCurrencyButton(image: "dollarsign")
        }
        view.updateSumLabel(text: textForShowInSumLabel(isI: mainScreenModel.isI, isRub: mainScreenModel.isRub, conversionRate: mainScreenModel.conversionRate))
    }
    
    private func textForShowInSumLabel(isI: Bool, isRub: Bool, conversionRate: Double) -> String {
        var sum: Int64 = 0
        
        if isI {
            sum = mainScreenModel.sumI.sum
        } else {
            sum = mainScreenModel.sumToMe.sum
        }
        
        if isRub {
            return "\(sum) руб"
        } else {
            let dollars = Double(sum) * conversionRate
            let roundedNumber = Double(String(format: "%.2f", dollars))!
            return "\(roundedNumber) $"
        }
    }
}

//MARK: - MainScreenInteractorOutputProtocol

extension MainScreenViewPresenter: MainScreenInteractorOutputProtocol {
    func sumIDidChange(sum: Sum) {
        mainScreenModel.sumI = sum
        if mainScreenModel.isI {
            view.updateSumLabel(text: textForShowInSumLabel(isI: mainScreenModel.isI, isRub: mainScreenModel.isRub, conversionRate: mainScreenModel.conversionRate))
        }
    }
    
    func sumToMeDidChange(sum: Sum) {
        mainScreenModel.sumToMe = sum
        if !mainScreenModel.isI {
            view.updateSumLabel(text: textForShowInSumLabel(isI: mainScreenModel.isI, isRub: mainScreenModel.isRub, conversionRate: mainScreenModel.conversionRate))
        }
    }
}
