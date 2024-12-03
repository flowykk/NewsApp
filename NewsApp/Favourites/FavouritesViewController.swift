import UIKit
import SnapKit

final class FavouritesViewController: UIViewController {
    
    private let titleView = UIView()
    private let FavouriteArticlesLabel = UILabel()
    private let FavouriteArticlesItemsLabel = UILabel()
    
    var viewModel: FavouritesViewModel? {
        didSet {
            viewModel?.didFetchedFavourites = { favourites in // TODO: [weak self]
                print(favourites)
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
        print("clear")
        //viewModel?.clearHistoryButtonTapped()
        //viewModel?.fetchHistory()
    }
}

extension FavouritesViewController {
    
    private func configureUI() {
        configureTitleView()
        configureClearHistoryButton()
        configureBackButton()
        configureNavigationBar()
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
        FavouriteArticlesLabel.textAlignment = .center
        FavouriteArticlesLabel.text = "Favourite Articles"
        FavouriteArticlesLabel.sizeToFit()
        FavouriteArticlesLabel.textColor = .black
        FavouriteArticlesLabel.font = .systemFont(ofSize: 17, weight: .bold)
        
        titleView.addSubview(FavouriteArticlesLabel)
        FavouriteArticlesLabel.snp.makeConstraints { make in
            make.top.equalTo(titleView)
            make.centerX.equalTo(titleView)
            make.width.equalTo(UIScreen.main.bounds.width * 0.6)
        }
    }
    
    private func configureSearchHistoryItemsLabel() {
        FavouriteArticlesItemsLabel.textAlignment = .center
        FavouriteArticlesItemsLabel.sizeToFit()
        FavouriteArticlesItemsLabel.text = "0 Items"
        FavouriteArticlesItemsLabel.textColor = .gray
        FavouriteArticlesItemsLabel.font = .systemFont(ofSize: 14, weight: .medium)
             
        titleView.addSubview(FavouriteArticlesItemsLabel)
        FavouriteArticlesItemsLabel.snp.makeConstraints { make in
            make.top.equalTo(FavouriteArticlesLabel.snp.bottom)
            make.bottom.equalTo(titleView).offset(-5)
            make.centerX.equalTo(titleView)
        }
    }
    
    private func configureTitleView() {
        configureSearchHistoryLabel()
        configureSearchHistoryItemsLabel()
    }
}
