import Moya
import Foundation

public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

public enum API {
    case getNews(keyword: String, page: Int, pageSize: Int, sortBy: String? = nil, language: String? = nil)
    case getNewsImage(imageURL: String)
}

extension API: TargetType {

    public var baseURL: URL {
        switch self {
        case .getNews:
            return URL(string: "https://newsapi.org")!
        case .getNewsImage(let imageURL):
            return URL(string: imageURL)!
        }
    }

    public var path: String {
        switch self {
        case .getNews:
            return "/v2/everything"
        case .getNewsImage:
            return ""
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getNews:
            return .get
        case .getNewsImage:
            return .get
        }
    }

    public var task: Task {
        switch self {
        case .getNews(let keyword, let page, let pageSize, let sortBy, let language):
            return .requestParameters(
                parameters: [
                    "q": keyword,
                    "page": page,
                    "pageSize": pageSize,
                    "sortBy": sortBy ?? "",
                    "language": language ?? ""
                ],
                encoding: URLEncoding.queryString
            )
        default:
            return .requestPlain
        }
    }

    public var headers: [String: String]? {
        return [
            "x-api-key": "111f4367e3044eac908d1478326902c6"
        ]
    }

    public var sampleData: Data {
        return Data()
    }
}
