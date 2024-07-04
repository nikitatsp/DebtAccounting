import UIKit

enum NetworkError: Error, LocalizedError {
    case noData
    case codeError(Int)
    case requestError
    
    var errorDescription: String? {
        switch self {
        case .noData:
            return "Data is empty"
        case .codeError(let statusCode):
            return "Code error: \(statusCode)"
        case .requestError:
            return "Invalid request"
        }
    }
}

struct NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    func fetch(request: URLRequest, completion: @escaping(_ result: Result<Data, Error>) -> Void) -> URLSessionTask {
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                completion(.failure(error))
                print("Network manager: eror exists")
                return
            }
            
            if let response = response as? HTTPURLResponse,
                response.statusCode < 200 || response.statusCode >= 300 {
                completion(.failure(NetworkError.codeError(response.statusCode)))
                print("Network manager/fetch: error in response: \(NetworkError.codeError(response.statusCode).localizedDescription)")
                return
            }

            if let data {
                completion(.success(data))
            } else {
                completion(.failure(NetworkError.noData))
                print("Network manager/fetch: error in data: \(NetworkError.noData.localizedDescription)")
                return
            }
        }
        return task
    }
}
