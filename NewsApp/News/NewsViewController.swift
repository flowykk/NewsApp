import UIKit
import SnapKit

final class NewsViewController: UIViewController {
    
    private var searchText: String? = nil
    private var isFiltering: Bool = false
    
    private let titleView = UIView()
    private let searchTextLabel = UILabel()
    private let totalResultsLabel = UILabel()
    
    private let tableView = NewsTableView()
    private let emptyLabel = EmptyLabel(message: "Start searching News here! 🔎")
    
    private var favouriteButton = UIBarButtonItem()
    private var sortingButton = UIBarButtonItem()

    var viewModel: NewsViewModelDelegate? {
        didSet{
            viewModel?.didFetchedNews = { [weak self] response in
                self?.totalResultsLabel.text = "\(response.totalResults ?? 0) Results"
                
                let filteredArticles = response.articles.filter { article in
                    article.title != "[Removed]"
                }

                self?.tableView.setData(with: filteredArticles)
                
                if filteredArticles.isEmpty {
                    self?.tableView.isHidden = true
                    
                    self?.emptyLabel.setMessage(message: "No results for such search! 🥀")
                    self?.emptyLabel.isHidden = false
                } else {
                    self?.tableView.isHidden = false
                    self?.emptyLabel.isHidden = true
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        
        configureSearchBar()
    }
    
    func sortTable(bySortBy sortBy: String?) {
        isFiltering = true
        self.tableView.clearData()
        guard let searchText = self.searchText else { return }
        self.viewModel?.fetchNews(keyword: searchText, sortBy: sortBy, needToSave: true)
    }
    
    func resetSort() {
        isFiltering = false
        
        
        self.tableView.clearData()
        guard let searchText = self.searchText else { return }
        self.viewModel?.fetchNews(keyword: searchText, needToSave: false)
    }
}

extension NewsViewController {
    
    @objc
    private func historyButtonTapped() {
        viewModel?.historyButtonTapped()
    }
    
    @objc
    private func favouritesButtonTapped() {
        viewModel?.favouritesButtonTapped()
    }
    
    @objc
    func showSortOptions() {
        
        if tableView.articles.isEmpty {
            viewModel?.filterButtonTappedWithNoData()
        }
        
        let alertController = UIAlertController(title: "Sort Articles", message: "Choose sorting parameter", preferredStyle: .actionSheet)
        
        let sortByPublishDate = UIAlertAction(title: "Publish Date", style: .default) { [unowned self] _ in
            self.sortTable(bySortBy: "publishedAt")
        }
        let sortByRelevancy = UIAlertAction(title: "Relevancy", style: .default) { [unowned self] _ in
            self.sortTable(bySortBy: "relevancy")
        }
        let sortByPopularity = UIAlertAction(title: "Popularity", style: .default) { [unowned self] _ in
            self.sortTable(bySortBy: "popularity")
        }
        let resetSort = UIAlertAction(title: "Reset sort settings", style: .default) { [unowned self] _ in
            self.resetSort()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(sortByPublishDate)
        alertController.addAction(sortByRelevancy)
        alertController.addAction(sortByPopularity)
        alertController.addAction(resetSort)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension NewsViewController {
    
    private func configureUI() {
        configureSearchBar()
        
        configureTitleView()
        configureHistoryButton()
        configureRightBarItems()
        configureNavigationBar()
        
        configureTableView()
        configureEmptyLabel()
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
        searchTextLabel.textColor = Colors.primaryTextColor
        searchTextLabel.font = .systemFont(ofSize: 17, weight: .bold)
        
        titleView.addSubview(searchTextLabel)
        searchTextLabel.snp.makeConstraints { make in
            make.top.equalTo(titleView)
            make.centerX.equalTo(titleView)
            make.width.equalTo(UIScreen.main.bounds.width * 0.6)
        }
    }
    
    private func configureTotalResultsLabel() {
        totalResultsLabel.textAlignment = .center
        totalResultsLabel.text = "0 Results"
        totalResultsLabel.sizeToFit()
        totalResultsLabel.textColor = Colors.tertiaryTextColor
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
    
    private func configureFavouriteButton() {
        let favsLargeFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
        let favsConfiguration = UIImage.SymbolConfiguration(font: favsLargeFont)
        let favsImage = UIImage(systemName: "star", withConfiguration: favsConfiguration)
        
        favouriteButton = UIBarButtonItem(
            image: favsImage,
            style: .plain,
            target: self,
            action: #selector(favouritesButtonTapped)
        )
        
        favouriteButton.tintColor = Colors.primaryTextColor
    }
    
    private func configureSortingButton() {
        let sortLargeFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
        let sortConfiguration = UIImage.SymbolConfiguration(font: sortLargeFont)
        let sortImage = UIImage(systemName: "line.3.horizontal.decrease", withConfiguration: sortConfiguration)
        
        sortingButton = UIBarButtonItem(
            image: sortImage,
            style: .plain,
            target: self,
            action: #selector(showSortOptions)
        )
        
        sortingButton.tintColor = Colors.primaryTextColor
    }
    
    private func configureRightBarItems() {
        configureFavouriteButton()
        configureSortingButton()
        
        navigationItem.rightBarButtonItems = [favouriteButton, sortingButton]
    }
    
    private func configureHistoryButton() {
        let largeFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let image = UIImage(systemName: "clock", withConfiguration: configuration)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(historyButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = Colors.primaryTextColor
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
    
    private func configureEmptyLabel() {
        view.addSubview(emptyLabel)
        emptyLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension NewsViewController: NewsTableViewDelegate {
    
    func didSelectRow(with article: Article) {
        viewModel?.articleDidTapped(with: article.url ?? "")
    }
    
    func didScrolledToBottom() {
        guard let searchText = self.searchText else { return }
        viewModel?.fetchNews(keyword: searchText)
    }
}

extension NewsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            searchTextLabel.text = "News Feed"
            return
        }
        
        searchTextLabel.text = "News about \(searchText)"
        self.searchText = searchText
        
        tableView.clearData()
        print(isFiltering)
        viewModel?.fetchNews(keyword: searchText, needToSave: true)
        
        searchBar.resignFirstResponder()
    }
}

// MARK: - UINavigationControllerDelegate
extension NewsViewController: UINavigationControllerDelegate {
    func navigationController(
        _ navigationController: UINavigationController,
        animationControllerFor operation: UINavigationController.Operation,
        from fromVC: UIViewController,
        to toVC: UIViewController
    ) -> UIViewControllerAnimatedTransitioning? {
        if operation == .push {
            if toVC is HistoryViewController {
                return PushTransitioning()
            }
        }
        return nil
    }
}
