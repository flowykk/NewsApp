import Moya
import Foundation

public protocol Networkable {
    var provider: MoyaProvider<API> { get }

    func fetchNews<T: Codable>(
        keyword: String,
        page: Int,
        pageSize: Int,
        sortBy: String?,
        language: String?,
        completion: @escaping (Result<T, Error>) -> Void
    )
    func fetchNewsImage(for imageURL: String, completion: @escaping (Result<Data, Error>) -> Void)
}

public final class NetworkManager: Networkable {

    public var provider = MoyaProvider<API>()

    nonisolated(unsafe) public static let shared = NetworkManager()

    public func fetchNews<T: Codable>(
        keyword: String,
        page: Int,
        pageSize: Int,
        sortBy: String?,
        language: String?,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        request(
            API.getNews(
                keyword: keyword,
                page: page,
                pageSize: pageSize,
                sortBy: sortBy,
                language: language
            ),
            completion: completion
        )
    }

    public func fetchNewsImage(for imageURL: String, completion: @escaping (Result<Data, Error>) -> Void) {
        request(API.getNewsImage(imageURL: imageURL), completion: completion)
    }
}

extension NetworkManager {

    private func request<T: Codable>(_ target: API, completion: @escaping (Result<T, Error>) -> Void) {
        provider.request(target) { result in
            switch result {
            case let .success(response):
                do {
                    if T.self == Data.self {
                        if let data = response.data as? T {
                            completion(.success(data))
                        } else {
                            completion(.failure(NetworkError.dataConversionFailure))
                        }
                        return
                    }

                    let result = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(result))
                } catch {
                    completion(.failure(NetworkError.dataConversionFailure))
                }
            case .failure:
                completion(.failure(NetworkError.invalidResponse))
            }
        }
    }
}
