import Foundation

protocol DebtListInteractorInputProtocol {
    init(presenter: DebtListInteractorOutputProtocol)
    func loadInitalData(isActive: Bool)
    func createNewRow(isI: Bool, isActive: Bool, lastDebt: Debt?, newDebt: Debt, sectionsITo: [Section], sectionsToMe: [Section])
}

protocol DebtListInteractorOutputProtocol: AnyObject {
    func recieveInitalData(sectionsITo: [Section], sectionToMe: [Section])
    func didRecieveNewRow(sectionsITo: [Section], sectionToMe: [Section])
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
    
    func createNewRow(isI: Bool, isActive: Bool, lastDebt: Debt?, newDebt: Debt, sectionsITo: [Section], sectionsToMe: [Section]) {
        var newSectionsITo = sectionsITo
        var newSectionsToMe = sectionsToMe
        
        
        guard let newDebtDate = newDebt.date else {return}
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
                presenter.didRecieveNewRow(sectionsITo: newSectionsITo, sectionToMe: newSectionsToMe)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
