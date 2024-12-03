import UIKit
import SnapKit

final class NewsViewController: UIViewController {
    
    private let tableView = NewsTableView()
    
    var viewModel: NewsViewModelDelegate? {
        didSet {
            tableView.viewModel = viewModel
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}

extension NewsViewController {
    
    private func configureUI() {
        configureSearchBar()
        configureTableView()
    }
    
    private func configureSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search articles"
        searchController.searchBar.delegate = self
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension NewsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        tableView.viewModel?.fetchNews(keyword: searchText, page: 1, pageSize: 10)
        searchBar.resignFirstResponder()
    }
}
