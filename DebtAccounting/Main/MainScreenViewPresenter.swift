import Foundation

struct MainScreenModel {
    var isI: Bool = true
    var sumI: Int64 = 0
    var sumToMe: Int64 = 0
    var isRub = true
    var conversionRate: Double = ConversionRateService.shared.conversionRate?.rate ?? 0
}

final class MainScreenViewPresenter: MainScreenViewControllerOutputProtocol {
    weak var view: MainScreenViewControllerInputProtocol!
    var interactor: MainScreenInteractorInputProtocol!
    private var mainScreenModel: MainScreenModel
    
    init(view: MainScreenViewControllerInputProtocol!) {
        self.view = view
        self.mainScreenModel = MainScreenModel()
    }
    
    private let conversionRateService = ConversionRateService.shared
    private let notifications = Notifications.shared
    
    
    func viewDidLoad() {
        addObserver()
    }
    
    private func addObserver() {
        NotificationCenter.default.addObserver(forName: notifications.sumIDidChange, object: nil, queue: .main) {notification in
            
            
        }

        NotificationCenter.default.addObserver(forName: notifications.sumToMeDidChange, object: nil, queue: .main) {notification in
            
            
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
            sum = mainScreenModel.sumI
        } else {
            sum = mainScreenModel.sumToMe
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
    
}
