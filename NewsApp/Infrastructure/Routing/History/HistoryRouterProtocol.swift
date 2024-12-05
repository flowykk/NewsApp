protocol HistoryRouterProtocol {
    var view: HistoryViewController? { get }
    
    func navigateToNews()
    
    func presentClearHistoryAlert()
    func presentEmptyHistoryAlert()
}
