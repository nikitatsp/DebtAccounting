import Foundation

final class DebtListPresenterHelper {
    static let shared = DebtListPresenterHelper()
    private init() {}
    
    func publicSumNotification(name: NSNotification.Name, sum: Int64) {
        let userInfo: [AnyHashable: Any] = ["newSum": sum]
        NotificationCenter.default.post(name: name, object: nil, userInfo: userInfo)
    }
}
