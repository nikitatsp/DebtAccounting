import Foundation

struct ExchangeRateResponse: Codable {
    let conversionRate: Double
    
    enum CodingKeys: String, CodingKey {
        case conversionRate = "conversion_rate"
    }
}
