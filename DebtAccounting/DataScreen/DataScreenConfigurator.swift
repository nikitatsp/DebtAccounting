import Foundation

protocol DataScreenConfiguratorInputProtocol {
    func configureDataScreen(withView view: DataScreenViewController, debt: Debt?, isI: Bool, isActive: Bool, delegate: DataScreenViewControllerDelegate)
}

final class DataScreenConfigurator: DataScreenConfiguratorInputProtocol {
    static let shared = DataScreenConfigurator()
    private init() {}
    
    func configureDataScreen(withView view: DataScreenViewController, debt: Debt?, isI: Bool, isActive: Bool, delegate: DataScreenViewControllerDelegate) {
        let presenter = DataScreenViewPresenter(view: view, isI: isI, isActive: isActive, debt: debt, delegate: delegate)
        let interactor = DataScreenInteractor(presenter: presenter)
        
        view.presenter = presenter
        presenter.interactor = interactor
    }
}
