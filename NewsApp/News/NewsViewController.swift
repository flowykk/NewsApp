import UIKit
import SnapKit

final class NewsViewController: UIViewController {
    
    private let titleView = UIView()
    private let searchTextLabel = UILabel()
    private let totalResultsLabel = UILabel()
    
    private let tableView = NewsTableView()
    
    var viewModel: NewsViewModelDelegate? {
        didSet{
            viewModel?.didFetchedNews = { [weak self] response in
                self?.totalResultsLabel.text = "\(response.totalResults ?? 0) Results"
                self?.tableView.setData(with: response.articles)
            }
            viewModel?.fetchNews(keyword: "food", page: 1, pageSize: 100)
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
        
        configureTitleView()
        configureNavigationBar()
        
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
    
    private func configureSearchTextLabel() {
        searchTextLabel.textAlignment = .center
        searchTextLabel.text = "News Feed"
        searchTextLabel.sizeToFit()
        searchTextLabel.textColor = .black
        searchTextLabel.font = .systemFont(ofSize: 17, weight: .bold)
        
        titleView.addSubview(searchTextLabel)
        searchTextLabel.snp.makeConstraints { make in
            make.top.equalTo(titleView)
            make.centerX.equalTo(titleView)
        }
    }
    
    private func configureTotalResultsLabel() {
        totalResultsLabel.textAlignment = .center
        totalResultsLabel.text = "0 Results"
        totalResultsLabel.sizeToFit()
        totalResultsLabel.textColor = .gray
        totalResultsLabel.font = .systemFont(ofSize: 14, weight: .medium)
             
        titleView.addSubview(totalResultsLabel)
        totalResultsLabel.snp.makeConstraints { make in
            make.top.equalTo(searchTextLabel.snp.bottom)
            make.bottom.equalTo(titleView).offset(-5)
            make.centerX.equalTo(titleView)
        }
    }
    
    private func configureTitleView() {
        configureSearchTextLabel()
        configureTotalResultsLabel()
    }
    
    private func configureNavigationBar() {
        navigationItem.titleView = titleView
    }
    
    private func configureTableView() {
        tableView.customDelegate = self
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension NewsViewController: NewsTableViewDelegate {
    
    func didSelectRow(with article: Article) {
        viewModel?.articleDidTapped(with: article.url ?? "")
    }
}

extension NewsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            searchTextLabel.text = "News"
            return
        }
        
        searchTextLabel.text = "News about \(searchText)"
        viewModel?.fetchNews(keyword: searchText, page: 1, pageSize: 10)
        
        searchBar.resignFirstResponder()
    }
}
