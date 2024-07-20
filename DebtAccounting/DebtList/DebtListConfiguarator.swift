import Foundation

enum ListType {
    case active
    case history
}

protocol DebtListConfiguaratorInputProtocol {
    func configure(withView view: DebtListViewController, andType type: ListType)
}

final class DebtListConfiguarator: DebtListConfiguaratorInputProtocol {
    func configure(withView view: DebtListViewController, andType type: ListType) {
        let presenter = DebtListPresenter(view: view, typePresenter: type)
        let interactor = DebtListInteractor(presenter: presenter, typeOfInteractor: type)
        let router = DebtListRouter(view: view)
        
        view.presenter = presenter
        presenter.interactor = interactor
        presenter.router = router
    }
}
