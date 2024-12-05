import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class NewsViewController: UIViewController {

    internal var searchText: String?

    internal var sortParameter = BehaviorRelay<String?>(value: nil)
    internal var languageParameter = BehaviorRelay<String?>(value: nil)
    private let disposeBag = DisposeBag()

    private let titleView = UIView()
    private let searchTextLabel = UILabel()
    private let totalResultsLabel = UILabel()

    internal let tableView = NewsTableView()
    private let emptyLabel = EmptyLabel(message: "Start searching News here! 🔎")

    private var historyButton = UIBarButtonItem()
    private var languageButton = UIBarButtonItem()

    private var favouriteButton = UIBarButtonItem()
    private var sortingButton = UIBarButtonItem()

    var viewModel: NewsViewModelDelegate? {
        didSet {
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
            make.width.equalTo(UIScreen.main.bounds.width * 0.42)
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
        let largeFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let image = UIImage(systemName: "globe.europe.africa.fill", withConfiguration: configuration)

        languageButton = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(showLanguageFilterOptions)
        )

        subscribeLanguageButton()
        languageButton.tintColor = Colors.tertiaryTextColor
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

        subscribeSortingButton()
        sortingButton.tintColor = Colors.tertiaryTextColor
    }

    private func configureLeftBarItems() {
        configureHistoryButton()
        configureLanguageButton()

        navigationItem.leftBarButtonItems = [historyButton, languageButton]
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
        tableView.defaultDelegate = self
        tableView.paginationDelegate = self

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

extension NewsViewController {

    private func subscribeLanguageButton() {
        languageParameter
            .subscribe(onNext: { [weak self] parameter in
                self?.languageButton.tintColor =
                    parameter != nil ?  Colors.additionalTextColor : Colors.tertiaryTextColor
            })
            .disposed(by: disposeBag)
    }

    private func subscribeSortingButton() {
        sortParameter
            .subscribe(onNext: { [weak self] parameter in
                self?.sortingButton.tintColor =
                    parameter != nil ?  Colors.additionalTextColor : Colors.tertiaryTextColor
            })
            .disposed(by: disposeBag)
    }
}

extension NewsViewController: NewsTableViewDelegate, NewsTableViewPaginationDelegate {

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

        self.searchText = searchText
        searchTextLabel.text = searchText
        handleNewSearch()

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
