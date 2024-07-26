import Foundation

final class DateService {
    static let shared = DateService()
    private init() {}
    
    lazy var dateFormatterMonthAndYear = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "LLLL yyyy 'год'"
        
        return dateFormatter
    }()
    
    lazy var dateFormatterDayMonthAndYear = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "d MMMM yyyy 'года'"
        
        return dateFormatter
    }()
    
    func indexOfSection(in sections: [Section], withDate date: Date) -> Int? {
        let calendar = Calendar.current
        let targetComponents = calendar.dateComponents([.year, .month], from: date)
        
        for (index, section) in sections.enumerated() {
            guard let sectionDate = section.date else {return nil}
            let sectionComponents = calendar.dateComponents([.year, .month], from: sectionDate)
            if sectionComponents.year == targetComponents.year && sectionComponents.month == targetComponents.month {
                return index
            }
        }
        return nil
    }
    
    func compareDatesIgnoringDay(_ date1: Date, _ date2: Date) -> Bool {
        let calendar = Calendar.current
        
        let components1 = calendar.dateComponents([.year, .month], from: date1)
        let components2 = calendar.dateComponents([.year, .month], from: date2)
        
        return components1.year == components2.year && components1.month == components2.month
    }
}
