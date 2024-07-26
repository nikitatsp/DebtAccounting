import Foundation

final class DebtListConfiguarator {
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
