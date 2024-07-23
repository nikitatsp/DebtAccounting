import Foundation

protocol DebtListInteractorInputProtocol {
    init(presenter: DebtListInteractorOutputProtocol)
    func loadInitalData(isActive: Bool)
    func toogleIsRub(isRub: Bool)
    func toogleIsI(isI: Bool)
    func insertNewIRow(newDebt: Debt, sectionsITo: [Section])
    func insertNewToMeRow(newDebt: Debt, sectionsToMe: [Section])
    func removeIRow(indexPath: IndexPath, sectionsITo: [Section])
    func removeToMeRow(indexPath: IndexPath, sectionsToMe: [Section])
    func toogleIsActive(debt: Debt)
    func editedRow(isI: Bool, isActive: Bool, indexOfLastSection: Int, newDebt: Debt, lastSum: Int64, sectionsITo: [Section], sectionsToMe: [Section])
}

protocol DebtListInteractorOutputProtocol: AnyObject {
    func isRubDidChange(isRub: Bool)
    func isIDidChange(isI: Bool)
    func didRecieveNewRow(sectionsITo: [Section])
    func didRecieveNewRow(sectionToMe: [Section])
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
        var newIsRub = !isRub
        presenter.isRubDidChange(isRub: newIsRub)
    }
    
    func toogleIsI(isI: Bool) {
        var newIsI = !isI
        presenter.isIDidChange(isI: newIsI)
    }
    
    func insertNewIRow(newDebt: Debt, sectionsITo: [Section]) {
        var newSectionsITo = sectionsITo
        
        guard let newDebtDate = newDebt.date else {
            print("Ошибка из-за новой даты")
            return
        }
        
        if let indexOfSection = dateService.indexOfSection(in: newSectionsITo, withDate: newDebtDate) {
            newSectionsITo[indexOfSection].addToDebts(newDebt)
            guard let sortedArr = newSectionsITo[indexOfSection].debts?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
            newSectionsITo[indexOfSection].debts = NSOrderedSet(array: sortedArr)
        } else {
            let section = debtListService.createNewSection(with: newDebt)
            newSectionsITo.append(section)
            newSectionsITo.sort { $0.date ?? Date() < $1.date ?? Date() }
        }
        
        coreDataService.saveContextWith { [weak self] in
            self?.presenter.didRecieveNewRow(sectionsITo: newSectionsITo)
        }
    }
    
    func insertNewToMeRow(newDebt: Debt, sectionsToMe: [Section]) {
        var newSectionsToMe = sectionsToMe
        
        guard let newDebtDate = newDebt.date else {
            print("Ошибка из-за новой даты")
            return
        }
        
        if let indexOfSection = dateService.indexOfSection(in: newSectionsToMe, withDate: newDebtDate) {
            newSectionsToMe[indexOfSection].addToDebts(newDebt)
            guard let sortedArr = newSectionsToMe[indexOfSection].debts?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
            newSectionsToMe[indexOfSection].debts = NSOrderedSet(array: sortedArr)
        } else {
            let section = debtListService.createNewSection(with: newDebt)
            newSectionsToMe.append(section)
            newSectionsToMe.sort { $0.date ?? Date() < $1.date ?? Date() }
        }
        
        coreDataService.saveContextWith { [weak self] in
            self?.presenter.didRecieveNewRow(sectionToMe: newSectionsToMe)
        }
    }
    
    func removeIRow(indexPath: IndexPath, sectionsITo: [Section]) {
        var newSectionsITo = sectionsITo
        
        guard let sectionCount = newSectionsITo[indexPath.section].debts?.count else {
            print("DebtListInteractor/newSectionsITo: sectionCount is nil")
            return
        }
        
        guard let debt = newSectionsITo[indexPath.section].debts?[indexPath.row] as? Debt else {
            print("DebtListInteractor/newSectionsITo: debt is nil")
            return
        }
        
        if sectionCount > 1 {
            newSectionsITo[indexPath.section].removeFromDebts(debt)
        } else {
            newSectionsITo[indexPath.section].removeFromDebts(debt)
            coreDataService.deleteFromContex(object: newSectionsITo[indexPath.section])
            newSectionsITo.remove(at: indexPath.section)
        }
        
        coreDataService.saveContextWith { [weak self] in
            self?.presenter.didRecieveNewRow(sectionsITo: newSectionsITo)
        }
    }
    
    func removeToMeRow(indexPath: IndexPath, sectionsToMe: [Section]) {
        var newSectionsToMe = sectionsToMe
        
        guard let sectionCount = newSectionsToMe[indexPath.section].debts?.count else {
            print("DebtListInteractor/newSectionsITo: sectionCount is nil")
            return
        }
        
        guard let debt = newSectionsToMe[indexPath.section].debts?[indexPath.row] as? Debt else {
            print("DebtListInteractor/newSectionsITo: debt is nil")
            return
        }
        
        if sectionCount > 1 {
            newSectionsToMe[indexPath.section].removeFromDebts(debt)
        } else {
            newSectionsToMe[indexPath.section].removeFromDebts(debt)
            coreDataService.deleteFromContex(object: newSectionsToMe[indexPath.section])
            newSectionsToMe.remove(at: indexPath.section)
        }
        
        coreDataService.saveContextWith { [weak self] in
            self?.presenter.didRecieveNewRow(sectionToMe: newSectionsToMe)
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
    
    func editedRow(isI: Bool, isActive: Bool, indexOfLastSection: Int, newDebt: Debt, lastSum: Int64, sectionsITo: [Section], sectionsToMe: [Section]) {
//        var newSectionsITo = sectionsITo
//        var newSectionsToMe = sectionsToMe
//        
//        guard let newDebtDate = newDebt.date else {
//            print("Ошибка из-за новой даты")
//            return
//        }
//        
//        if isI {
//            if dateService.compareDatesIgnoringDay(newDebtDate, newSectionsITo[indexOfLastSection].date ?? Date()) {
//                guard let sortedArr = newSectionsITo[indexOfLastSection].debts?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
//                newSectionsITo[indexOfLastSection].debts = NSOrderedSet(array: sortedArr)
//            } else {
//                
//                guard let lastSectionDebtsCount = newSectionsITo[indexOfLastSection].debts?.count else {
//                    print("DebtListInteractor/editedRow: lastSectionDebtsCount is nil")
//                    return
//                }
//                
//                if lastSectionDebtsCount > 1 {
//                    newSectionsITo[indexOfLastSection].removeFromDebts(newDebt)
//                } else {
//                    newSectionsITo[indexOfLastSection].removeFromDebts(newDebt)
//                    context.delete(newSectionsITo[indexOfLastSection])
//                    newSectionsITo.remove(at: indexOfLastSection)
//                }
//                
//                if let indexOfSection = dateService.indexOfSection(in: newSectionsITo, withDate: newDebtDate) {
//                    newSectionsITo[indexOfSection].addToDebts(newDebt)
//                    
//                    guard let sortedArr = newSectionsITo[indexOfSection].debts?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
//                    newSectionsITo[indexOfSection].debts = NSOrderedSet(array: sortedArr)
//                } else {
//                    let section = Section(context: context)
//                    section.date = newDebtDate
//                    section.isActive = isActive
//                    section.isI = isI
//                    section.addToDebts(newDebt)
//                    newSectionsITo.append(section)
//                    
//                    newSectionsITo.sort { $0.date ?? Date() < $1.date ?? Date() }
//                }
//            }
//            
//            do {
//                try context.save()
//                presenter.didRecieveNewRow(sectionsITo: newSectionsITo)
//            } catch {
//                print(error.localizedDescription)
//            }
//            
//            let userInfo: [AnyHashable: Any] = ["newSumI": newDebt.sum - lastSum]
//            NotificationCenter.default.post(name: Notifications.shared.sumIDidChange, object: nil, userInfo: userInfo)
//        } else {
//            if dateService.compareDatesIgnoringDay(newDebtDate, newSectionsToMe[indexOfLastSection].date ?? Date()) {
//                guard let sortedArr = newSectionsToMe[indexOfLastSection].debts?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
//                newSectionsToMe[indexOfLastSection].debts = NSOrderedSet(array: sortedArr)
//            } else {
//                
//                guard let lastSectionDebtsCount = newSectionsToMe[indexOfLastSection].debts?.count else {
//                    print("DebtListInteractor/editedRow: lastSectionDebtsCount is nil")
//                    return
//                }
//                
//                if lastSectionDebtsCount > 1 {
//                    newSectionsToMe[indexOfLastSection].removeFromDebts(newDebt)
//                } else {
//                    newSectionsToMe[indexOfLastSection].removeFromDebts(newDebt)
//                    context.delete(newSectionsToMe[indexOfLastSection])
//                    newSectionsToMe.remove(at: indexOfLastSection)
//                }
//                
//                if let indexOfSection = dateService.indexOfSection(in: newSectionsToMe, withDate: newDebtDate) {
//                    newSectionsToMe[indexOfSection].addToDebts(newDebt)
//                    
//                    guard let sortedArr = newSectionsToMe[indexOfSection].debts?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
//                    newSectionsToMe[indexOfSection].debts = NSOrderedSet(array: sortedArr)
//                } else {
//                    let section = Section(context: context)
//                    section.date = newDebtDate
//                    section.isActive = isActive
//                    section.isI = isI
//                    section.addToDebts(newDebt)
//                    newSectionsToMe.append(section)
//                    
//                    newSectionsToMe.sort { $0.date ?? Date() < $1.date ?? Date() }
//                }
//            }
//            
//            do {
//                try context.save()
//                presenter.didRecieveNewRow(sectionToMe: newSectionsToMe)
//            } catch {
//                print(error.localizedDescription)
//            }
//            
//            let userInfo: [AnyHashable: Any] = ["newSumToMe": newDebt.sum - lastSum]
//            NotificationCenter.default.post(name: Notifications.shared.sumToMeDidChange, object: nil, userInfo: userInfo)
//        }
    }
}
