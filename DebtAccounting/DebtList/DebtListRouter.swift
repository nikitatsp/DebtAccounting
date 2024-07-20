import Foundation

protocol DebtListRouterInputProtocol {
    init(view: DebtListViewController)
    func openDataViewController()
}

final class DebtListRouter: DebtListRouterInputProtocol {
    let view: DebtListViewController
    
    init(view: DebtListViewController) {
        self.view = view
    }
    
    func openDataViewController() {
        
    }
}
