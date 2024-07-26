import Foundation

final class MainScreenViewPresenterHelper {
    static let shared = MainScreenViewPresenterHelper()
    private init() {}
    
    func textForShowInSumLabel(isI: Bool, isRub: Bool, conversionRate: Double, mainScreenModel: MainScreenModel) -> String {
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
