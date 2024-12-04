import UIKit
import SnapKit

final class FavouritesViewController: UIViewController {
    
    private let titleView = UIView()
    private let favouriteArticlesLabel = UILabel()
    private let favouriteArticlesItemsLabel = UILabel()
    
    private let tableView = NewsTableView()
    private let emptyLabel = EmptyLabel(
        message: "You have no favorite articles yet! 😢\nSave some News to your favorites! ⭐️"
    )
    
    var viewModel: FavouritesViewModel? {
        didSet {
            viewModel?.didFetchedFavourites = { [weak self] favourites in
                self?.favouriteArticlesItemsLabel.text = "\(favourites.count) Items"
                
                self?.tableView.setData(with: favourites)
                
                if favourites.isEmpty {
                    self?.tableView.isHidden = true
                    self?.emptyLabel.isHidden = false
                } else {
                    self?.tableView.isHidden = false
                    self?.emptyLabel.isHidden = true
                }
            }
            viewModel?.fetchFavourites()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        configureUI()
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
        viewModel?.fetchFavourites()
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
        navigationItem.rightBarButtonItem?.tintColor = .systemPink
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
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    private func configureSearchHistoryLabel() {
        favouriteArticlesLabel.textAlignment = .center
        favouriteArticlesLabel.text = "Favourite Articles"
        favouriteArticlesLabel.sizeToFit()
        favouriteArticlesLabel.textColor = .black
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
        favouriteArticlesItemsLabel.textColor = .gray
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
