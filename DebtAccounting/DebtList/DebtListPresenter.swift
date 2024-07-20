import Foundation

enum IndexOfSegmentedControl {
    case first
    case second
}

struct PresenterState {
    var isI = true
    var isActive: Bool
    var isRub = true
    var sectionsITo: [Section] = []
    var sectionsToMe: [Section] = []
}

final class DebtListPresenter: DebtListViewControllerOutputProtocol {
    weak var view: DebtListViewControllerInputProtocol!
    var interactor: DebtListInteractorInputProtocol!
    var router: DebtListRouterInputProtocol!
    var state: PresenterState!
    
    
    init(view: DebtListViewControllerInputProtocol, isActive: Bool) {
        self.view = view
        self.state = PresenterState(isActive: isActive)
    }
    
    func viewDidLoad() {
        if state.isActive {
            view.setTextForTableViewHeader(text: "Активные долги")
            view.setImageForRightBarButton(withSystemName: "plus")
        } else {
            view.setTextForTableViewHeader(text: "История")
            view.setImageForRightBarButton(withSystemName: "slider.horizontal.3")
        }
        interactor.loadInitalData()
    }
    
    func didCurrencyBarButtonTapped() {
        if state.isRub {
            state.isRub = false
            view.setImageForCurrencyButton(withSystemName: "dollarsign")
            view.reloadDataForTableView()
        } else {
            state.isRub = true
            view.setImageForCurrencyButton(withSystemName: "rublesign")
            view.reloadDataForTableView()
        }
    }
    
    func rightBarButtonTapped() {
        if state.isActive {
            router.openDataViewController()
        } else {
            view.toogleEditTableView()
        }
    }
    
    func segmentedControlDidChange() {
        if state.isI {
            state.isI = false
        } else {
            state.isI = true
        }
        view.reloadDataForTableView()
    }
    
    func numberOfSections() -> Int {
        if state.isI {
            return state.sectionsITo.count
        } else {
            return state.sectionsToMe.count
        }
    }
    
    func numberOfRowsInSection(at index: Int) -> Int {
        if state.isI {
            guard let count = state.sectionsITo[index].debts?.count else {
                print("DebtListPresenter/numberOfRowsInSection: count of sectionsITo is nil")
                return 0
            }
            return count
        } else {
            guard let count = state.sectionsToMe[index].debts?.count else {
                print("DebtListPresenter/numberOfRowsInSection: count of sectionsToMe is nil")
                return 0
            }
            return count
        }
    }
    
    func configureCell(_ cell: DebtListCell, with indexPath: IndexPath) {
        if state.isI {
            guard let debt = state.sectionsITo[indexPath.section].debts?[indexPath.row] as? Debt else {
                print("DebtListPresenter/configureCell: model is nil")
            }
            let cellState = StateModelDebtListCell(debt: debt, delegate: self, isRub: state.isRub)
        } else {
            guard let model = state.sectionsToMe[indexPath.section].debts?[indexPath.row] as? Debt else {
                print("DebtListPresenter/configureCell: model is nil")
            }
            let cellState = StateModelDebtListCell(model: model, delegate: self, isRub: state.isRub)
        }
    }
    
    func commitDeleteEdittingStyle(indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ contentOffset: CGPoint) {
        if contentOffset.y > 60 {
            if state.isActive {
                view.setTittleForNavigationController(text: "Активные долги")
            } else {
                view.setTittleForNavigationController(text: "История")
            }
        } else {
            view.setTittleForNavigationController(text: "")
        }
    }
}

//MARK: - DebtListInteractorOutputProtocol

extension DebtListPresenter: DebtListInteractorOutputProtocol {
    func recieveInitalData(sectionsITo: [Section], sectionToMe: [Section]) {
        state.sectionsITo = sectionsITo
        state.sectionsToMe = sectionToMe
    }
}

//MARK: - DebtListCellDelegate

extension DebtListPresenter: DebtListCellDelegate {
    func didButtonInCellTapped(_ cell: DebtListCell) {
        <#code#>
    }
}
