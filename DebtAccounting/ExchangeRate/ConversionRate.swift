import Foundation

final class ConversionRateService {
    static let shared = ConversionRateService()
    private init() {}
    
    var conversionRate = 0.01
}
