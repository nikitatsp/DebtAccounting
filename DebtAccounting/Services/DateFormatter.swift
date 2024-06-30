import Foundation

struct FormatDate {
    static let shared = FormatDate()
    private init() {}
    
    func formatDateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "ru_RU")
        
        dateFormatter.dateFormat = "d MMMM yyyy 'год'"
        
        let formattedDate = dateFormatter.string(from: date)
        
        return formattedDate
    }
}
