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
    
    private var historyButton = UIBarButtonItem()
    private var languageButton = UIBarButtonItem()
    
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
    
    func filterTable(sortBy: String? = nil, language: String? = nil) {
        isFiltering = true
        tableView.clearData()
        viewModel?.resetCurrentPage()
        guard let searchText = searchText else { return }
        viewModel?.fetchNews(
            keyword: searchText,
            sortBy: sortBy == FilterSettings.resetSettings.rawValue ? nil : sortBy,
            language: language == LanguageSettings.resetSettings.rawValue ? nil : language?.getLanguageCode(),
            needToSave: false
        )
    }
    
    func resetSort() {
        isFiltering = false
        tableView.clearData()
        viewModel?.resetCurrentPage()
        guard let searchText = searchText else { return }
        viewModel?.fetchNews(keyword: searchText, needToSave: false)
    }
    
    func prepareAlertActions(withVariation variation: FilterVariations) -> [UIAlertAction] {
        var actions = [UIAlertAction]()
        let sortParameters = variation == FilterVariations.language ?
            LanguageSettings.allCases.map { $0.rawValue } :
            FilterSettings.allCases.map { $0.rawValue }
        
        for parameter in sortParameters {
            let action = UIAlertAction(title: parameter, style: .default) { [unowned self] _ in
                variation == FilterVariations.language ?
                    self.filterTable(language: parameter) :
                    self.filterTable(sortBy: parameter)
            }
            actions.append(action)
        }
        
        actions.append(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        return actions
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
    private func showLanguageFilterOptions() {
        if tableView.articles.isEmpty {
            viewModel?.filterButtonTappedWithNoData()
        }
        
        let alertController = UIAlertController(
            title: "Filter articles by language",
            message: "Choose language",
            preferredStyle: .actionSheet
        )

        let actions = prepareAlertActions(withVariation: .language)
        for action in actions {
            alertController.addAction(action)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc
    private func showSortingFilterOptions() {
        if tableView.articles.isEmpty {
            viewModel?.filterButtonTappedWithNoData()
        }
        
        let alertController = UIAlertController(
            title: "Sort articles",
            message: "Choose sorting parameter",
            preferredStyle: .actionSheet
        )

        let actions = prepareAlertActions(withVariation: .sorting)
        for action in actions {
            alertController.addAction(action)
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
}

extension NewsViewController {
    
    private func configureUI() {
        configureSearchBar()
        
        configureTitleView()
        configureHistoryButton()
        configureLeftBarItems()
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
    
    private func configureHistoryButton() {
        let largeFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let image = UIImage(systemName: "clock", withConfiguration: configuration)
        
        historyButton = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(historyButtonTapped))
        historyButton.tintColor = Colors.primaryTextColor
    }
    
    private func configureLanguageButton() {
        let sortLargeFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
        let sortConfiguration = UIImage.SymbolConfiguration(font: sortLargeFont)
        let sortImage = UIImage(systemName: "globe.europe.africa.fill", withConfiguration: sortConfiguration)
        
        languageButton = UIBarButtonItem(
            image: sortImage,
            style: .plain,
            target: self,
            action: #selector(showLanguageFilterOptions)
        )
        
        languageButton.tintColor = Colors.primaryTextColor
    }
    
    private func configureLeftBarItems() {
        configureHistoryButton()
        configureLanguageButton()
        
        navigationItem.leftBarButtonItems = [historyButton, languageButton]
    }
    
    private func configureFavouriteButton() {
        let largeFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let image = UIImage(systemName: "star", withConfiguration: configuration)
        
        favouriteButton = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(favouritesButtonTapped)
        )
        
        favouriteButton.tintColor = Colors.primaryTextColor
    }
    
    private func configureSortingButton() {
        let largeFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let image = UIImage(systemName: "line.3.horizontal.decrease", withConfiguration: configuration)
        
        sortingButton = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(showSortingFilterOptions)
        )
        
        sortingButton.tintColor = Colors.primaryTextColor
    }
    
    private func configureRightBarItems() {
        configureFavouriteButton()
        configureSortingButton()
        
        navigationItem.rightBarButtonItems = [favouriteButton, sortingButton]
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
        viewModel?.resetCurrentPage()
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
