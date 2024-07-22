import Foundation

protocol MainScreenInteractorInputProtocol {
    
}

protocol MainScreenInteractorOutputProtocol: AnyObject {
    
}

final class MainScreenInteractor: MainScreenInteractorInputProtocol {
    weak var presenter: MainScreenInteractorOutputProtocol!
    
    init(presenter: MainScreenInteractorOutputProtocol) {
        self.presenter = presenter
    }
}
