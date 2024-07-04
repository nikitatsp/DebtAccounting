import UIKit

struct ExchangeRateService {
    static let shared = ExchangeRateService()
    private init() {}
    let networkManager = NetworkManager.shared
    
    private func makeRequest() -> URLRequest? {
        guard let url = URL(string: "https://v6.exchangerate-api.com/v6/\(ApiKey.apiKey)/pair/RUB/USD") else { print("ExchangeRateService/makeRequest: invalid URL")
            return nil
        }
        return URLRequest(url: url)
    }
    
    func fetchExchangeRate(completion: @escaping(_ result: Result<Double, Error>) -> Void) {
        guard let request = makeRequest() else { print("ExchangeRateService/fetchExchangeRate: invalid request")
            return
        }
        let task = networkManager.fetch(request: request) { result in
            switch result {
            case .success(let data):
                do {
                    let model = try JSONDecoder().decode(ExchangeRateResponse.self, from: data)
                    let conversionRate = model.conversionRate
                    completion(.success(conversionRate))
                } catch {
                    print("ExchangeRateService/fetchExchangeRate: DecodingError")
                    completion(.failure(error))
                }
            case .failure(let error):
                print("ExchangeRateService/fetchExchangeRate: NetworkError")
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
