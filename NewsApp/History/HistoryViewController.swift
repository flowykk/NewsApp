import UIKit
import SnapKit

final class HistoryViewController: UIViewController {
    
    private let tableView = HistoryTableView()
    
    var viewModel: HistoryViewModelDelegate? {
        didSet {
            viewModel?.didFetchedHistory = { [weak self] history in
                self?.tableView.setData(with: history)
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
        viewModel?.fetchHistory()
    }
}

extension HistoryViewController {
    
    private func configureUI() {
        configureNavigationBar()
        configureClearHistoryButton()
        configureBackButton()
        
        configureTableView()
    }
    
    private func configureNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationItem.title = "Search History"
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
    
    private func configureTableView() {
        tableView.customDelegate = self
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension HistoryViewController: HistoryTableViewDelegate {
    
    func didDeleteRow(with search: SearchHistoryItem) {
        print(1)
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
