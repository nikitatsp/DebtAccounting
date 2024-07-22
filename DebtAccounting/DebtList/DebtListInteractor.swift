import Foundation

protocol DebtListInteractorInputProtocol {
    init(presenter: DebtListInteractorOutputProtocol)
    func loadInitalData(isActive: Bool)
    func createNewRow(isI: Bool, isActive: Bool, newDebt: Debt, sectionsITo: [Section], sectionsToMe: [Section])
    func editedRow(isI: Bool, isActive: Bool, indexOfLastSection: Int, newDebt: Debt, lastSum: Int64, sectionsITo: [Section], sectionsToMe: [Section])
}

protocol DebtListInteractorOutputProtocol: AnyObject {
    func recieveInitalData(sectionsITo: [Section], sectionToMe: [Section])
    func didRecieveNewRow(sectionsITo: [Section])
    func didRecieveNewRow(sectionToMe: [Section])
}

final class DebtListInteractor: DebtListInteractorInputProtocol {
    
    weak var presenter: DebtListInteractorOutputProtocol!
    let debtListService = DebtListService.shared
    let dateService = DateService.shared
    let context = CoreDataService.shared.getContext()
    
    init(presenter: DebtListInteractorOutputProtocol) {
        self.presenter = presenter
    }
    
    func loadInitalData(isActive: Bool) {
        let sectionsITo = debtListService.loadInitalDataITo(for: isActive)
        let sectionsToMe = debtListService.loadInitalDataToMe(for: isActive)
        presenter.recieveInitalData(sectionsITo: sectionsITo, sectionToMe: sectionsToMe)
    }
    
    func createNewRow(isI: Bool, isActive: Bool, newDebt: Debt, sectionsITo: [Section], sectionsToMe: [Section]) {
        var newSectionsITo = sectionsITo
        var newSectionsToMe = sectionsToMe
        
        guard let newDebtDate = newDebt.date else {
            print("Ошибка из-за новой даты")
            return
        }
        
        if isI {
            if let indexOfSection = dateService.indexOfSection(in: newSectionsITo, withDate: newDebtDate) {
                newSectionsITo[indexOfSection].addToDebts(newDebt)
                
                guard let sortedArr = newSectionsITo[indexOfSection].debts?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
                newSectionsITo[indexOfSection].debts = NSOrderedSet(array: sortedArr)
            } else {
                let section = Section(context: context)
                section.date = newDebtDate
                section.isActive = isActive
                section.isI = isI
                section.addToDebts(newDebt)
                newSectionsITo.append(section)
                
                newSectionsITo.sort { $0.date ?? Date() < $1.date ?? Date() }
            }
            
            do {
                try context.save()
                presenter.didRecieveNewRow(sectionsITo: newSectionsITo)
            } catch {
                print(error.localizedDescription)
            }
            
            let userInfo: [AnyHashable: Any] = ["newSumI": newDebt.sum]
            NotificationCenter.default.post(name: Notifications.shared.sumIDidChange, object: nil, userInfo: userInfo)
        } else {
            if let indexOfSection = dateService.indexOfSection(in: newSectionsToMe, withDate: newDebtDate) {
                newSectionsToMe[indexOfSection].addToDebts(newDebt)
                
                guard let sortedArr = newSectionsToMe[indexOfSection].debts?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
                newSectionsToMe[indexOfSection].debts = NSOrderedSet(array: sortedArr)
            } else {
                let section = Section(context: context)
                section.date = newDebtDate
                section.isActive = isActive
                section.isI = isI
                section.addToDebts(newDebt)
                newSectionsToMe.append(section)
                
                newSectionsToMe.sort { $0.date ?? Date() < $1.date ?? Date() }
            }
            
            do {
                try context.save()
                presenter.didRecieveNewRow(sectionToMe: newSectionsToMe)
            } catch {
                print(error.localizedDescription)
            }
            
            let userInfo: [AnyHashable: Any] = ["newSumToMe": newDebt.sum]
            NotificationCenter.default.post(name: Notifications.shared.sumToMeDidChange, object: nil, userInfo: userInfo)
        }
    }
    
    func editedRow(isI: Bool, isActive: Bool, indexOfLastSection: Int, newDebt: Debt, lastSum: Int64, sectionsITo: [Section], sectionsToMe: [Section]) {
        var newSectionsITo = sectionsITo
        var newSectionsToMe = sectionsToMe
        
        guard let newDebtDate = newDebt.date else {
            print("Ошибка из-за новой даты")
            return
        }
        
        if isI {
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
                    context.delete(newSectionsITo[indexOfLastSection])
                    newSectionsITo.remove(at: indexOfLastSection)
                }
                
                if let indexOfSection = dateService.indexOfSection(in: newSectionsITo, withDate: newDebtDate) {
                    newSectionsITo[indexOfSection].addToDebts(newDebt)
                    
                    guard let sortedArr = newSectionsITo[indexOfSection].debts?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
                    newSectionsITo[indexOfSection].debts = NSOrderedSet(array: sortedArr)
                } else {
                    let section = Section(context: context)
                    section.date = newDebtDate
                    section.isActive = isActive
                    section.isI = isI
                    section.addToDebts(newDebt)
                    newSectionsITo.append(section)
                    
                    newSectionsITo.sort { $0.date ?? Date() < $1.date ?? Date() }
                }
            }
            
            do {
                try context.save()
                presenter.didRecieveNewRow(sectionsITo: newSectionsITo)
            } catch {
                print(error.localizedDescription)
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
                    context.delete(newSectionsToMe[indexOfLastSection])
                    newSectionsToMe.remove(at: indexOfLastSection)
                }
                
                if let indexOfSection = dateService.indexOfSection(in: newSectionsToMe, withDate: newDebtDate) {
                    newSectionsToMe[indexOfSection].addToDebts(newDebt)
                    
                    guard let sortedArr = newSectionsToMe[indexOfSection].debts?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {return}
                    newSectionsToMe[indexOfSection].debts = NSOrderedSet(array: sortedArr)
                } else {
                    let section = Section(context: context)
                    section.date = newDebtDate
                    section.isActive = isActive
                    section.isI = isI
                    section.addToDebts(newDebt)
                    newSectionsToMe.append(section)
                    
                    newSectionsToMe.sort { $0.date ?? Date() < $1.date ?? Date() }
                }
            }
            
            do {
                try context.save()
                presenter.didRecieveNewRow(sectionToMe: newSectionsToMe)
            } catch {
                print(error.localizedDescription)
            }
            
            let userInfo: [AnyHashable: Any] = ["newSumToMe": newDebt.sum - lastSum]
            NotificationCenter.default.post(name: Notifications.shared.sumToMeDidChange, object: nil, userInfo: userInfo)
        }
    }
}
