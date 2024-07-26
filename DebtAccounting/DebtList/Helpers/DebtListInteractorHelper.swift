import Foundation

final class DebtListInteractorHelper {
    static let shared = DebtListInteractorHelper()
    private init() {}
    
    let coreDataService = CoreDataService.shared
    let debtListService = DebtListService.shared
    let dateService = DateService.shared
    
    func insertRowToSectionAndSort(sections: [Section], newDebt: Debt) -> [Section] {
        var newSections = sections
        
        guard let newDebtDate = newDebt.date else {
            print("DebtListInteractorHelper/insertRowToSectionAndSort: newDebtDate is nil")
            return []
        }
        
        if let indexOfSection = dateService.indexOfSection(in: newSections, withDate: newDebtDate) {
            newSections[indexOfSection].addToDebts(newDebt)
            guard let sortedArr = newSections[indexOfSection].debts?.sortedArray(using: [NSSortDescriptor(key: "date", ascending: true)]) else {
                print("DebtListInteractorHelper/insertRowToSectionAndSort: sortedArr is nil")
                return []
            }
            newSections[indexOfSection].debts = NSOrderedSet(array: sortedArr)
        } else {
            let section = debtListService.createNewSection(with: newDebt)
            newSections.append(section)
            newSections.sort { $0.date ?? Date() < $1.date ?? Date() }
        }
        return newSections
    }
    
    func removeDebtFromSection(sections: [Section], debt: Debt, indexOfSection: Int) -> (newSections: [Section], shouldRemoveSection: Bool) {
        var newSections = sections
        var shouldRemoveSection = false
        
        guard let sectionCount = newSections[indexOfSection].debts?.count else {
            print("DebtListInteractorHelper/removeDebtFromSection: sectionCount is nil")
            return ([], shouldRemoveSection)
        }
        
        if sectionCount > 1 {
            newSections[indexOfSection].removeFromDebts(debt)
        } else {
            newSections[indexOfSection].removeFromDebts(debt)
            let section = newSections[indexOfSection]
            newSections.remove(at: indexOfSection)
            coreDataService.deleteFromContex(object: section)
            shouldRemoveSection = true
        }
        
        return (newSections, shouldRemoveSection)
    }
}
