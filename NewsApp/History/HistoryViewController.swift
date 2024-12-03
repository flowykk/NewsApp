import UIKit
import SnapKit

final class HistoryViewController: UIViewController {
    
    var viewModel: HistoryViewModelDelegate? {
        didSet {
            viewModel?.didFetchedHistory = { history in // [weak self]
                //print(history)
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
}

extension HistoryViewController {
    
    private func configureUI() {
        configureNavigationBar()
        configureBackButton()
    }
    
    private func configureNavigationBar() {
        navigationItem.hidesBackButton = true
        navigationItem.title = "Search History"
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
