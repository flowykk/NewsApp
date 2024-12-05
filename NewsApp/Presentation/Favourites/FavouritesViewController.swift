import UIKit
import SnapKit
import RxSwift
import RxCocoa

final class FavouritesViewController: UIViewController {
    
    private let titleView = UIView()
    private let favouriteArticlesLabel = UILabel()
    private let favouriteArticlesItemsLabel = UILabel()
    
    private let tableView = NewsTableView()
    private let emptyLabel = EmptyLabel(
        message: "You have no favorite articles yet! 😢\nSave some News to your favorites! ⭐️"
    )
    
    private let disposeBag = DisposeBag()
    
    var viewModel: FavouritesViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Colors.backgroundColor
        
        configureUI()
        configureBinding()
        
        viewModel?.fetchFavourites()
    }
    
    private func ifEmptyLabelNeeded(with favourites: [Article]) {
        if favourites.isEmpty {
            tableView.isHidden = true
            emptyLabel.isHidden = false
        } else {
            tableView.isHidden = false
            emptyLabel.isHidden = true
        }
    }
}

extension FavouritesViewController {
    
    @objc
    private func backButtonTapped() {
        viewModel?.backButtonTapped()
    }
    
    @objc
    private func clearHistoryButtonTapped() {
        viewModel?.clearFavouritesButtonTapped()
    }
}

extension FavouritesViewController {
    
    private func configureBinding() {
        bindViewModelFavourites()
    }
    
    private func bindViewModelFavourites() {
        viewModel?.favourites
            .asObservable()
            .bind { [weak self] favourites in
                self?.favouriteArticlesItemsLabel.text = "\(favourites.count) Items"
                self?.tableView.setData(with: favourites)
                self?.ifEmptyLabelNeeded(with: favourites)
            }
            .disposed(by: disposeBag)
    }
}

extension FavouritesViewController {
    
    private func configureUI() {
        configureTitleView()
        configureClearHistoryButton()
        configureBackButton()
        configureNavigationBar()
        
        configureTableView()
        configureEmptyLabel()
    }
    
    private func configureNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationItem.titleView = titleView
    }
    
    private func configureClearHistoryButton() {
        let largeFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let image = UIImage(systemName: "trash.fill", withConfiguration: configuration)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(clearHistoryButtonTapped))
        navigationItem.rightBarButtonItem?.tintColor = Colors.trashColor
    }
    
    private func configureBackButton() {
        let largeFont = UIFont.systemFont(ofSize: 18, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let image = UIImage(systemName: "chevron.left", withConfiguration: configuration)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        navigationItem.leftBarButtonItem?.tintColor = Colors.primaryTextColor
    }
    
    private func configureSearchHistoryLabel() {
        favouriteArticlesLabel.textAlignment = .center
        favouriteArticlesLabel.text = "Favourite Articles"
        favouriteArticlesLabel.sizeToFit()
        favouriteArticlesLabel.textColor = Colors.primaryTextColor
        favouriteArticlesLabel.font = .systemFont(ofSize: 17, weight: .bold)
        
        titleView.addSubview(favouriteArticlesLabel)
        favouriteArticlesLabel.snp.makeConstraints { make in
            make.top.equalTo(titleView)
            make.centerX.equalTo(titleView)
            make.width.equalTo(UIScreen.main.bounds.width * 0.6)
        }
    }
    
    private func configureSearchHistoryItemsLabel() {
        favouriteArticlesItemsLabel.textAlignment = .center
        favouriteArticlesItemsLabel.sizeToFit()
        favouriteArticlesItemsLabel.textColor = Colors.tertiaryTextColor
        favouriteArticlesItemsLabel.font = .systemFont(ofSize: 14, weight: .medium)
             
        titleView.addSubview(favouriteArticlesItemsLabel)
        favouriteArticlesItemsLabel.snp.makeConstraints { make in
            make.top.equalTo(favouriteArticlesLabel.snp.bottom)
            make.bottom.equalTo(titleView).offset(-5)
            make.centerX.equalTo(titleView)
        }
    }
    
    private func configureTitleView() {
        configureSearchHistoryLabel()
        configureSearchHistoryItemsLabel()
    }
    
    private func configureTableView() {
        tableView.defaultDelegate = self
        
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

extension FavouritesViewController: NewsTableViewDelegate {
    
    func didSelectRow(with article: Article) {
        viewModel?.articleDidTapped(with: article.url ?? "")
    }
}
