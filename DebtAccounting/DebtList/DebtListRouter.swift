import Foundation

protocol DebtListRouterInputProtocol {
    init(view: DebtListViewController)
    func openDataViewController(debt: Debt?, indexOfLastSection: Int?, isI: Bool, isActive: Bool, delegate: DataScreenViewControllerDelegate)
}

final class DebtListRouter: DebtListRouterInputProtocol {
    let view: DebtListViewController
    
    init(view: DebtListViewController) {
        self.view = view
    }
    
    func openDataViewController(debt: Debt?, indexOfLastSection: Int?, isI: Bool, isActive: Bool, delegate: DataScreenViewControllerDelegate) {
        let dataScreenController = DataScreenViewController()
        DataScreenConfigurator.shared.configureDataScreen(withView: dataScreenController, debt: debt, indexOfLastSection: indexOfLastSection, isI: isI, isActive: isActive, delegate: delegate)
        view.navigationController?.pushViewController(dataScreenController, animated: true)
    }
}
