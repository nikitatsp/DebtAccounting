import Foundation

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
    var debtListModel: DebtListModel
    
    private let dateService = DateService.shared
    private let notifications = Notifications.shared
    
    init(view: DebtListViewControllerInputProtocol, isActive: Bool) {
        self.view = view
        self.debtListModel = DebtListModel(isActive: isActive)
    }
    
    func viewDidLoad(with header: TableViewHeader) {
        if debtListModel.isActive {
            header.setDataInHeader(text: "Активные долги")
            view.setImageForRightBarButton(withSystemName: "plus")
        } else {
            header.setDataInHeader(text: "История")
            view.setImageForRightBarButton(withSystemName: "slider.horizontal.3")
        }
        interactor.loadInitalData(isActive: debtListModel.isActive)
        addObserver(isActive: debtListModel.isActive)
    }
    
    private func addObserver(isActive: Bool) {
        if debtListModel.isActive {
            NotificationCenter.default.addObserver(forName: notifications.sectionsIToActiveDidChange, object: nil, queue: .main) { [weak self] notification in
                guard let self else {return}
                guard let userInfo = notification.userInfo else {
                    print("DebtListPresenter/addObserver: userInfo is nil")
                    return
                }
                guard let newDebt = userInfo["newRow"] as? Debt else {
                    print("DebtListPresenter/addObserver: newRow is nil")
                    return
                }
                
                self.interactor.insertNewIRow(newDebt: newDebt, sectionsITo: self.debtListModel.sectionsITo)
                
                let userInfoSum: [AnyHashable: Any] = ["newSumI": newDebt.sum]
                NotificationCenter.default.post(name: self.notifications.sumIDidChange, object: nil, userInfo: userInfoSum)
            }
            
            NotificationCenter.default.addObserver(forName: notifications.sectionsToMeActiveDidChange, object: nil, queue: .main) { [weak self] notification in
                guard let self else {return}
                guard let userInfo = notification.userInfo else {
                    print("DebtListPresenter/addObserver: userInfo is nil")
                    return
                }
                guard let newDebt = userInfo["newRow"] as? Debt else {
                    print("DebtListPresenter/addObserver: newRow is nil")
                    return
                }
                
                self.interactor.insertNewToMeRow(newDebt: newDebt, sectionsToMe: debtListModel.sectionsToMe)
                
                let userInfoSum: [AnyHashable: Any] = ["newSumToMe": newDebt.sum]
                NotificationCenter.default.post(name: self.notifications.sumToMeDidChange, object: nil, userInfo: userInfoSum)
            }
        } else {
            NotificationCenter.default.addObserver(forName: notifications.sectionsIToHistoryDidChange, object: nil, queue: .main) { [weak self] notification in
                print("Получена нотификация")
                guard let self else {
                    print("не получена нотификация")
                    return}
                guard let userInfo = notification.userInfo else {
                    print("DebtListPresenter/addObserver: userInfo is nil")
                    return
                }
                guard let newDebt = userInfo["newRow"] as? Debt else {
                    print("DebtListPresenter/addObserver: newRow is nil")
                    return
                }
                
                self.interactor.insertNewIRow(newDebt: newDebt, sectionsITo: self.debtListModel.sectionsITo)
                
                let userInfoSum: [AnyHashable: Any] = ["newSumI": -newDebt.sum]
                NotificationCenter.default.post(name: self.notifications.sumIDidChange, object: nil, userInfo: userInfoSum)
            }
            
            NotificationCenter.default.addObserver(forName: notifications.sectionsToMeHistoryDidChange, object: nil, queue: .main) { [weak self] notification in
                guard let self else {return}
                guard let userInfo = notification.userInfo else {
                    print("DebtListPresenter/addObserver: userInfo is nil")
                    return
                }
                guard let newDebt = userInfo["newRow"] as? Debt else {
                    print("DebtListPresenter/addObserver: newRow is nil")
                    return
                }
                
                self.interactor.insertNewToMeRow(newDebt: newDebt, sectionsToMe: debtListModel.sectionsToMe)
                
                let userInfoSum: [AnyHashable: Any] = ["newSumToMe": -newDebt.sum]
                NotificationCenter.default.post(name: self.notifications.sumToMeDidChange, object: nil, userInfo: userInfoSum)
            }
        }
    }
    
    func didCurrencyBarButtonTapped() {
        interactor.toogleIsRub(isRub: debtListModel.isRub)
    }
    
    func rightBarButtonTapped() {
        if debtListModel.isActive {
            router.openDataViewController(debt: nil, indexOfLastSection: nil, isI: debtListModel.isI, isActive: debtListModel.isActive, delegate: self)
        } else {
            view.toogleEditTableView()
        }
    }
    
    func segmentedControlDidChange() {
        interactor.toogleIsI(isI: debtListModel.isI)
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
            let debtListCellModel = DebtListCellModel(debt: debt, delegate: self, isRub: debtListModel.isRub)
            cell.debtListCellModel = debtListCellModel
        } else {
            guard let debt = debtListModel.sectionsToMe[indexPath.section].debts?[indexPath.row] as? Debt else {
                print("DebtListPresenter/configureCell: model is nil")
                return
            }
            let debtListCellModel = DebtListCellModel(debt: debt, delegate: self, isRub: debtListModel.isRub)
            cell.debtListCellModel = debtListCellModel
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
    
    func configureSectionHeader(header: TableSectionHeader, section: Int) {
        if debtListModel.isI {
            guard let sectionDate = debtListModel.sectionsITo[section].date else {return}
            let text = dateService.monthAndYear(date: sectionDate)
            header.setDataInHeader(text: text)
        } else {
            guard let sectionDate = debtListModel.sectionsToMe[section].date else {return}
            let text = dateService.monthAndYear(date: sectionDate)
            header.setDataInHeader(text: text)
        }
    }
    
    func didSelectedRow(at indexPath: IndexPath) {
        if debtListModel.isI {
            guard let debt = debtListModel.sectionsITo[indexPath.section].debts?[indexPath.row] as? Debt else {
                print("DebtListPresenter/didSelectedRow: debt is nil")
                return
            }
            router.openDataViewController(debt: debt, indexOfLastSection: indexPath.section, isI: debtListModel.isI, isActive: debtListModel.isActive, delegate: self)
        } else {
            guard let debt = debtListModel.sectionsToMe[indexPath.section].debts?[indexPath.row] as? Debt else {
                print("DebtListPresenter/didSelectedRow: debt is nil")
                return
            }
            router.openDataViewController(debt: debt, indexOfLastSection: indexPath.section, isI: debtListModel.isI, isActive: debtListModel.isActive, delegate: self)
        }
    }
}

//MARK: - DebtListInteractorOutputProtocol

extension DebtListPresenter: DebtListInteractorOutputProtocol {    
    func didRecieveNewRow(sectionsITo: [Section]) {
        debtListModel.sectionsITo = sectionsITo
        if debtListModel.isI {
            view.reloadDataForTableView()
        }
    }
    
    func didRecieveNewRow(sectionToMe: [Section]) {
        debtListModel.sectionsToMe = sectionToMe
        if !debtListModel.isI {
            view.reloadDataForTableView()
        }
    }
    
    func isRubDidChange(isRub: Bool) {
        debtListModel.isRub = isRub
        if debtListModel.isRub {
            view.setImageForCurrencyButton(withSystemName: "rublesign")
        } else {
            view.setImageForCurrencyButton(withSystemName: "dollarsign")
        }
        view.reloadDataForTableView()
    }
    
    func isIDidChange(isI: Bool) {
        debtListModel.isI = isI
        view.reloadDataForTableView()
    }
}

//MARK: - DebtListCellDelegate

extension DebtListPresenter: DebtListCellDelegate {
    func didButtonInCellTapped(_ cell: DebtListCell, debt: Debt) {
        guard let indexPath = view.indexPathForRow(cell: cell) else {
            print("DebtListPresenter/didButtonInCellTapped: indexPath is nil")
            return
        }
        
        if debtListModel.isI {
            interactor.removeIRow(indexPath: indexPath, sectionsITo: debtListModel.sectionsITo)
        } else {
            interactor.removeToMeRow(indexPath: indexPath, sectionsToMe: debtListModel.sectionsToMe)
        }
        
        interactor.toogleIsActive(debt: debt)
    }
}

//MARK: - DataScreenViewControllerDelegate

extension DebtListPresenter: DataScreenViewControllerDelegate {
    func didCreatedNewDebt(newDebt: Debt) {
        view.popViewController()
        if newDebt.isI {
            interactor.insertNewIRow(newDebt: newDebt, sectionsITo: debtListModel.sectionsITo)
            let userInfo: [AnyHashable: Any] = ["newSumI": newDebt.sum]
            NotificationCenter.default.post(name: Notifications.shared.sumIDidChange, object: nil, userInfo: userInfo)
        } else {
            interactor.insertNewToMeRow(newDebt: newDebt, sectionsToMe: debtListModel.sectionsToMe)
            let userInfo: [AnyHashable: Any] = ["newSumToMe": newDebt.sum]
            NotificationCenter.default.post(name: Notifications.shared.sumToMeDidChange, object: nil, userInfo: userInfo)
        }
    }
    
    func didEditedDebt(indexOfLastSection: Int, newDebt: Debt, lastSum: Int64) {
        view.popViewController()
        interactor.editedRow(indexOfLastSection: indexOfLastSection, newDebt: newDebt, lastSum: lastSum, sectionsITo: debtListModel.sectionsITo, sectionsToMe: debtListModel.sectionsToMe)
    }
}
