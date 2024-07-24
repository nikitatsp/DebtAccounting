import Foundation

protocol DebtListInteractorInputProtocol {
    init(presenter: DebtListInteractorOutputProtocol)
    func loadInitalData(isActive: Bool)
    func toogleIsRub(isRub: Bool)
    func toogleIsI(isI: Bool)
    func insertNewRow(sections: [Section], newDebt: Debt)
    func removeRow(indexPath: IndexPath, sections: [Section], shouldDeleteDebt: Bool)
    func toogleIsActive(debt: Debt)
    func editedRow(indexOfLastSection: Int, newDebt: Debt, lastSum: Int64, sectionsITo: [Section], sectionsToMe: [Section])
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
        var newSections = sections
        
        guard let newDebtDate = newDebt.date else {
            print("Ошибка из-за новой даты")
            return
        }
        
        if let indexOfSection = dateService.indexOfSection(in: newSections, withDate: newDebtDate) {
            newSections[indexOfSection].addToDebts(newDebt)
            guard let sortedArr = newSections[indexOfSection].debts?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
            newSections[indexOfSection].debts = NSOrderedSet(array: sortedArr)
        } else {
            let section = debtListService.createNewSection(with: newDebt)
            newSections.append(section)
            newSections.sort { $0.date ?? Date() < $1.date ?? Date() }
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
        var newSections = sections
        var shouldRemoveSection = false
        
        guard let sectionCount = newSections[indexPath.section].debts?.count else {
            print("DebtListInteractor/newSectionsITo: sectionCount is nil")
            return
        }
        
        guard let debt = newSections[indexPath.section].debts?[indexPath.row] as? Debt else {
            print("DebtListInteractor/newSectionsITo: debt is nil")
            return
        }
        
        if sectionCount > 1 {
            newSections[indexPath.section].removeFromDebts(debt)
        } else {
            newSections[indexPath.section].removeFromDebts(debt)
            let section = newSections[indexPath.section]
            newSections.remove(at: indexPath.section)
            coreDataService.deleteFromContex(object: section)
            shouldRemoveSection = true
        }
        
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
    
    func editedRow(indexOfLastSection: Int, newDebt: Debt, lastSum: Int64, sectionsITo: [Section], sectionsToMe: [Section]) {
        var newSectionsITo = sectionsITo
        var newSectionsToMe = sectionsToMe
        
        guard let newDebtDate = newDebt.date else {
            print("Ошибка из-за новой даты")
            return
        }
        
        if newDebt.isI {
            if dateService.compareDatesIgnoringDay(newDebtDate, newSectionsITo[indexOfLastSection].date ?? Date()) {
                guard let sortedArr = newSectionsITo[indexOfLastSection].debts?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
                newSectionsITo[indexOfLastSection].debts = NSOrderedSet(array: sortedArr)
            } else {
                
                guard let lastSectionDebtsCount = newSectionsITo[indexOfLastSection].debts?.count else {
                    print("DebtListInteractor/editedRow: lastSectionDebtsCount is nil")
                    return
                }
                
                if lastSectionDebtsCount > 1 {
                    newSectionsITo[indexOfLastSection].removeFromDebts(newDebt)
                } else {
                    newSectionsITo[indexOfLastSection].removeFromDebts(newDebt)
                    coreDataService.deleteFromContex(object: newSectionsITo[indexOfLastSection])
                    newSectionsITo.remove(at: indexOfLastSection)
                }
                
                if let indexOfSection = dateService.indexOfSection(in: newSectionsITo, withDate: newDebtDate) {
                    newSectionsITo[indexOfSection].addToDebts(newDebt)
                    
                    guard let sortedArr = newSectionsITo[indexOfSection].debts?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
                    newSectionsITo[indexOfSection].debts = NSOrderedSet(array: sortedArr)
                } else {
                    let section = debtListService.createNewSection(with: newDebt)
                    section.addToDebts(newDebt)
                    newSectionsITo.append(section)
                    
                    newSectionsITo.sort { $0.date ?? Date() < $1.date ?? Date() }
                }
            }
            
            coreDataService.saveContextWith { [weak self] in
                self?.presenter.didRecieveNewRow(sectionsITo: newSectionsITo)
            }
            
            let userInfo: [AnyHashable: Any] = ["newSumI": newDebt.sum - lastSum]
            NotificationCenter.default.post(name: Notifications.shared.sumIDidChange, object: nil, userInfo: userInfo)
        } else {
            if dateService.compareDatesIgnoringDay(newDebtDate, newSectionsToMe[indexOfLastSection].date ?? Date()) {
                guard let sortedArr = newSectionsToMe[indexOfLastSection].debts?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
                newSectionsToMe[indexOfLastSection].debts = NSOrderedSet(array: sortedArr)
            } else {
                
                guard let lastSectionDebtsCount = newSectionsToMe[indexOfLastSection].debts?.count else {
                    print("DebtListInteractor/editedRow: lastSectionDebtsCount is nil")
                    return
                }
                
                if lastSectionDebtsCount > 1 {
                    newSectionsToMe[indexOfLastSection].removeFromDebts(newDebt)
                } else {
                    newSectionsToMe[indexOfLastSection].removeFromDebts(newDebt)
                    coreDataService.deleteFromContex(object: newSectionsToMe[indexOfLastSection])
                    newSectionsToMe.remove(at: indexOfLastSection)
                }
                
                if let indexOfSection = dateService.indexOfSection(in: newSectionsToMe, withDate: newDebtDate) {
                    newSectionsToMe[indexOfSection].addToDebts(newDebt)
                    
                    guard let sortedArr = newSectionsToMe[indexOfSection].debts?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
                    newSectionsToMe[indexOfSection].debts = NSOrderedSet(array: sortedArr)
                } else {
                    let section = debtListService.createNewSection(with: newDebt)
                    section.addToDebts(newDebt)
                    newSectionsToMe.append(section)
                    newSectionsToMe.sort { $0.date ?? Date() < $1.date ?? Date() }
                }
            }
            
            coreDataService.saveContextWith { [weak self] in
                self?.presenter.didRecieveNewRow(sectionToMe: newSectionsToMe)
            }
            
            let userInfo: [AnyHashable: Any] = ["newSumToMe": newDebt.sum - lastSum]
            NotificationCenter.default.post(name: Notifications.shared.sumToMeDidChange, object: nil, userInfo: userInfo)
        }
    }
}
