import Foundation

final class DataScreenConfigurator {
    static let shared = DataScreenConfigurator()
    private init() {}
    
    func configureDataScreen(withView view: DataScreenViewController, debt: Debt?, indexOfLastSection: Int?, isI: Bool, isActive: Bool, delegate: DataScreenViewControllerDelegate) {
        let presenter = DataScreenViewPresenter(view: view, isI: isI, isActive: isActive, debt: debt, indexOfLastSection: indexOfLastSection, delegate: delegate)
        let interactor = DataScreenInteractor(presenter: presenter)
        
        view.presenter = presenter
        presenter.interactor = interactor
    }
}
