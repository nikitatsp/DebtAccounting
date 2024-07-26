import Foundation

final class MainScreenConfigurator {
    static let shared = MainScreenConfigurator()
    private init() {}
    
    func configure(withView view: MainScreenViewController) {
        let presenter = MainScreenViewPresenter(view: view)
        let interactor = MainScreenInteractor(presenter: presenter)
        
        view.presenter = presenter
        presenter.interactor = interactor
    }
}
