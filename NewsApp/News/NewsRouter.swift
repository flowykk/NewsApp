import Foundation

protocol NewsRouterProtocol {
    var view: NewsViewController? { get set }
}

final class NewsRouter: NewsRouterProtocol {
    weak var view: NewsViewController?
}
