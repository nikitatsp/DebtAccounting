import Foundation

enum ListType {
    case active
    case history
}

protocol DebtListConfiguaratorInputProtocol {
    func configure(withView view: DebtListViewController, isActive: Bool)
}

final class DebtListConfiguarator: DebtListConfiguaratorInputProtocol {
    static let shared = DebtListConfiguarator()
    private init() {}
    
    func configure(withView view: DebtListViewController, isActive: Bool) {
        let presenter = DebtListPresenter(view: view, isActive: isActive)
        let interactor = DebtListInteractor(presenter: presenter)
        let router = DebtListRouter(view: view)
        
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
