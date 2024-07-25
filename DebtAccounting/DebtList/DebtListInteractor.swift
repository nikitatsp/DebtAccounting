import Foundation

protocol DebtListInteractorInputProtocol {
    init(presenter: DebtListInteractorOutputProtocol)
    func loadInitalData(isActive: Bool)
    func toogleIsRub(isRub: Bool)
    func toogleIsI(isI: Bool)
    func insertNewRow(sections: [Section], newDebt: Debt)
    func removeRow(indexPath: IndexPath, sections: [Section], shouldDeleteDebt: Bool)
    func toogleIsActive(debt: Debt)
    func editedRow(indexOfLastSection: Int, newDebt: Debt, sections: [Section])
}

protocol DebtListInteractorOutputProtocol: AnyObject {
    func isRubDidChange(isRub: Bool)
    func isIDidChange(isI: Bool)
    func didRecieveNewRow(sectionsITo: [Section])
    func didRecieveNewRow(sectionToMe: [Section])
    func didRemovedRow(sectionsITo: [Section], indexPath: IndexPath, shouldRemoveSection: Bool)
    func didRemovedRow(sectionToMe: [Section], indexPath: IndexPath, shouldRemoveSection: Bool)
}

final class DebtListInteractor: DebtListInteractorInputProtocol {
    
    weak var presenter: DebtListInteractorOutputProtocol!
    let debtListService = DebtListService.shared
    let dateService = DateService.shared
    let coreDataService = CoreDataService.shared
    let notifications = Notifications.shared
    let helper = DebtListInteractorHelper.shared
    
    init(presenter: DebtListInteractorOutputProtocol) {
        self.presenter = presenter
    }
    
    func loadInitalData(isActive: Bool) {
        let sectionsITo = debtListService.loadInitalDataITo(for: isActive)
        let sectionsToMe = debtListService.loadInitalDataToMe(for: isActive)
        presenter.didRecieveNewRow(sectionsITo: sectionsITo)
        presenter.didRecieveNewRow(sectionToMe: sectionsToMe)
    }
    
    func toogleIsRub(isRub: Bool) {
        let newIsRub = !isRub
        presenter.isRubDidChange(isRub: newIsRub)
    }
    
    func toogleIsI(isI: Bool) {
        let newIsI = !isI
        presenter.isIDidChange(isI: newIsI)
    }
    
    func insertNewRow(sections: [Section], newDebt: Debt) {
        let newSections = helper.insertRowToSectionAndSort(sections: sections, newDebt: newDebt)
        
        coreDataService.saveContextWith { [weak self] in
            if newDebt.isI {
                self?.presenter.didRecieveNewRow(sectionsITo: newSections)
            } else {
                self?.presenter.didRecieveNewRow(sectionToMe: newSections)
            }
        }
    }
    
    func editedRow(indexOfLastSection: Int, newDebt: Debt, sections: [Section]) {
        var newSections = sections
        
        guard let newDebtDate = newDebt.date else {
            print("Ошибка из-за новой даты")
            return
        }
        
        if dateService.compareDatesIgnoringDay(newDebtDate, newSections[indexOfLastSection].date ?? Date()) {
            guard let sortedArr = newSections[indexOfLastSection].debts?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
            newSections[indexOfLastSection].debts = NSOrderedSet(array: sortedArr)
        } else {
            newSections = helper.removeDebtFromSection(sections: newSections, debt: newDebt, indexOfSection: indexOfLastSection).newSections
            newSections = helper.insertRowToSectionAndSort(sections: newSections, newDebt: newDebt)
        }
        
        coreDataService.saveContextWith { [weak self] in
            if newDebt.isI {
                self?.presenter.didRecieveNewRow(sectionsITo: newSections)
            } else {
                self?.presenter.didRecieveNewRow(sectionToMe: newSections)
            }
        }
    }
    
    func removeRow(indexPath: IndexPath, sections: [Section], shouldDeleteDebt: Bool) {
        guard let debt = sections[indexPath.section].debts?[indexPath.row] as? Debt else {
            print("DebtListInteractor/newSectionsITo: debt is nil")
            return
        }
        
        let newSectionsAndShouldRemoveSection = helper.removeDebtFromSection(sections: sections, debt: debt, indexOfSection: indexPath.section)
        let newSections = newSectionsAndShouldRemoveSection.newSections
        let shouldRemoveSection = newSectionsAndShouldRemoveSection.shouldRemoveSection
        
        coreDataService.saveContextWith { [weak self] in
            if debt.isI {
                self?.presenter.didRemovedRow(sectionsITo: newSections, indexPath: indexPath, shouldRemoveSection: shouldRemoveSection)
            } else {
                self?.presenter.didRemovedRow(sectionToMe: newSections, indexPath: indexPath, shouldRemoveSection: shouldRemoveSection)
            }
        }
        
        if shouldDeleteDebt {
            coreDataService.deleteFromContex(object: debt)
            coreDataService.saveContextWith { }
        }
    }
    
    func toogleIsActive(debt: Debt) {
        debt.isActive.toggle()
        
        let userInfo: [AnyHashable: Any] = ["newRow": debt]
        if debt.isActive {
            if debt.isI {
                NotificationCenter.default.post(name: notifications.sectionsIToActiveDidChange, object: nil, userInfo: userInfo)
            } else {
                NotificationCenter.default.post(name: notifications.sectionsToMeActiveDidChange, object: nil, userInfo: userInfo)
            }
        } else {
            if debt.isI {
                NotificationCenter.default.post(name: notifications.sectionsIToHistoryDidChange, object: nil, userInfo: userInfo)
            } else {
                NotificationCenter.default.post(name: notifications.sectionsToMeHistoryDidChange, object: nil, userInfo: userInfo)
            }
        }
    }
}
