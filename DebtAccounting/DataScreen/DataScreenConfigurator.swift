import Foundation

protocol DataScreenConfiguratorInputProtocol {
    func configureDataScreen(withView view: DataScreenViewController, model: Model, indexOfSegmentedControl: IndexOfSegmentedControl)
}

final class DataScreenConfigurator: DataScreenConfiguratorInputProtocol {
    func configureDataScreen(withView view: DataScreenViewController, model: Model, indexOfSegmentedControl: IndexOfSegmentedControl) {
        let presenter = DataScreenViewPresenter(view: view, model: model)
        let interactor = DataScreenInteractor(presenter: presenter)
        
        view.presenter = presenter
        presenter.interactor = interactor
    }
}
