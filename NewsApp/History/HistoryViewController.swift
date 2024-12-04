import UIKit
import SnapKit

final class HistoryViewController: UIViewController {
    
    private let titleView = UIView()
    private let searchHistoryLabel = UILabel()
    private let searchHistoryItemsLabel = UILabel()
    
    private let tableView = HistoryTableView()
    private let emptyLabel = EmptyLabel(
        message: "You have no searches yet! 😢\nLet's Search for news together! 🤭"
    )
    
    var viewModel: HistoryViewModelDelegate? {
        didSet {
            viewModel?.didFetchedHistory = { [weak self] history in
                self?.searchHistoryItemsLabel.text = "\(history.count) Items"
                
                self?.tableView.setData(with: history)
                
                if history.isEmpty {
                    self?.tableView.isHidden = true
                    self?.emptyLabel.isHidden = false
                } else {
                    self?.tableView.isHidden = false
                    self?.emptyLabel.isHidden = true
                }
            }
            viewModel?.fetchHistory()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        view.backgroundColor = .white
        
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.delegate = self
    }
}

extension HistoryViewController {
    
    @objc
    private func backButtonTapped() {
        viewModel?.backButtonTapped()
    }
    
    @objc
    private func clearHistoryButtonTapped() {
        viewModel?.clearHistoryButtonTapped()
    }
}

extension HistoryViewController {
    
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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(clearHistoryButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = .systemPink
    }
    
    private func configureBackButton() {
        let largeFont = UIFont.systemFont(ofSize: 18, weight: .bold)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let image = UIImage(systemName: "chevron.right", withConfiguration: configuration)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(backButtonTapped)
        )
        navigationItem.rightBarButtonItem?.tintColor = .black
    }
    
    private func configureSearchHistoryLabel() {
        searchHistoryLabel.textAlignment = .center
        searchHistoryLabel.text = "Search History"
        searchHistoryLabel.sizeToFit()
        searchHistoryLabel.textColor = .black
        searchHistoryLabel.font = .systemFont(ofSize: 17, weight: .bold)
        
        titleView.addSubview(searchHistoryLabel)
        searchHistoryLabel.snp.makeConstraints { make in
            make.top.equalTo(titleView)
            make.centerX.equalTo(titleView)
            make.width.equalTo(UIScreen.main.bounds.width * 0.6)
        }
    }
    
    private func configureSearchHistoryItemsLabel() {
        searchHistoryItemsLabel.textAlignment = .center
        searchHistoryItemsLabel.sizeToFit()
        searchHistoryItemsLabel.textColor = .gray
        searchHistoryItemsLabel.font = .systemFont(ofSize: 14, weight: .medium)
             
        titleView.addSubview(searchHistoryItemsLabel)
        searchHistoryItemsLabel.snp.makeConstraints { make in
            make.top.equalTo(searchHistoryLabel.snp.bottom)
            make.bottom.equalTo(titleView).offset(-5)
            make.centerX.equalTo(titleView)
        }
    }
    
    private func configureTitleView() {
        configureSearchHistoryLabel()
        configureSearchHistoryItemsLabel()
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

extension HistoryViewController: HistoryTableViewDelegate {
    
    func didDeleteRow(with search: SearchHistoryItem) {
        viewModel?.deleteFromHistory(search: search)
    }
}

// MARK: - UINavigationControllerDelegate
extension HistoryViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == .pop {
            if toVC is NewsViewController {
                return PopTransitioning()
            }
        }
        return nil
    }
}
