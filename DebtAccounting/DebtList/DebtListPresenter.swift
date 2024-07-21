import Foundation

enum IndexOfSegmentedControl {
    case first
    case second
}

struct DebtListModel {
    var isI = true
    let isActive: Bool
    var isRub = true
    var sectionsITo: [Section] = []
    var sectionsToMe: [Section] = []
}

final class DebtListPresenter: DebtListViewControllerOutputProtocol {
    weak var view: DebtListViewControllerInputProtocol!
    var interactor: DebtListInteractorInputProtocol!
    var router: DebtListRouterInputProtocol!
    var debtListModel: DebtListModel!
    
    init(view: DebtListViewControllerInputProtocol, isActive: Bool) {
        self.view = view
        self.debtListModel = DebtListModel(isActive: isActive)
    }
    
    func viewDidLoad() {
        if debtListModel.isActive {
            view.setTextForTableViewHeader(text: "Активные долги")
            view.setImageForRightBarButton(withSystemName: "plus")
        } else {
            view.setTextForTableViewHeader(text: "История")
            view.setImageForRightBarButton(withSystemName: "slider.horizontal.3")
        }
        interactor.loadInitalData(isActive: debtListModel.isActive)
    }
    
    func didCurrencyBarButtonTapped() {
        if debtListModel.isRub {
            debtListModel.isRub = false
            view.setImageForCurrencyButton(withSystemName: "dollarsign")
            view.reloadDataForTableView()
        } else {
            debtListModel.isRub = true
            view.setImageForCurrencyButton(withSystemName: "rublesign")
            view.reloadDataForTableView()
        }
    }
    
    func rightBarButtonTapped() {
        if debtListModel.isActive {
            router.openDataViewController(debt: nil,isI: debtListModel.isI, isActive: debtListModel.isActive, delegate: self)
        } else {
            view.toogleEditTableView()
        }
    }
    
    func segmentedControlDidChange() {
        debtListModel.isI.toggle()
        view.reloadDataForTableView()
    }
    
    func numberOfSections() -> Int {
        if debtListModel.isI {
            return debtListModel.sectionsITo.count
        } else {
            return debtListModel.sectionsToMe.count
        }
    }
    
    func numberOfRowsInSection(at index: Int) -> Int {
        if debtListModel.isI {
            guard let count = debtListModel.sectionsITo[index].debts?.count else {
                print("DebtListPresenter/numberOfRowsInSection: count of sectionsITo is nil")
                return 0
            }
            return count
        } else {
            guard let count = debtListModel.sectionsToMe[index].debts?.count else {
                print("DebtListPresenter/numberOfRowsInSection: count of sectionsToMe is nil")
                return 0
            }
            return count
        }
    }
    
    func configureCell(_ cell: DebtListCell, with indexPath: IndexPath) {
        if debtListModel.isI {
            guard let debt = debtListModel.sectionsITo[indexPath.section].debts?[indexPath.row] as? Debt else {
                print("DebtListPresenter/configureCell: model is nil")
                return
            }
            let cellState = StateModelDebtListCell(debt: debt, delegate: self, isRub: debtListModel.isRub)
            cell.stateModelDebtListCell = cellState
        } else {
            guard let debt = debtListModel.sectionsToMe[indexPath.section].debts?[indexPath.row] as? Debt else {
                print("DebtListPresenter/configureCell: model is nil")
                return
            }
            let cellState = StateModelDebtListCell(debt: debt, delegate: self, isRub: debtListModel.isRub)
            cell.stateModelDebtListCell = cellState
        }
    }
    
    func commitDeleteEdittingStyle(indexPath: IndexPath) {
        
    }
    
    func scrollViewDidScroll(_ contentOffset: CGPoint) {
        if contentOffset.y > 60 {
            if debtListModel.isActive {
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
        debtListModel.sectionsITo = sectionsITo
        debtListModel.sectionsToMe = sectionToMe
    }
    
    func didRecieveNewRow(sectionsITo: [Section], sectionToMe: [Section]) {
        debtListModel.sectionsITo = sectionsITo
        debtListModel.sectionsToMe = sectionToMe
        view.reloadDataForTableView()
    }
}

//MARK: - DebtListCellDelegate

extension DebtListPresenter: DebtListCellDelegate {
    func didButtonInCellTapped(_ cell: DebtListCell) {
        
    }
}

//MARK: - DataScreenViewControllerDelegate

extension DebtListPresenter: DataScreenViewControllerDelegate {
    func didTapSaveBarButton(lastDebt: Debt?, newDebt: Debt) {
        view.popViewController()
        interactor.createNewRow(isI: debtListModel.isI, isActive: debtListModel.isActive, lastDebt: lastDebt, newDebt: newDebt, sectionsITo: debtListModel.sectionsITo, sectionsToMe: debtListModel.sectionsToMe)
    }
}
