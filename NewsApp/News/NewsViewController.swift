import UIKit
import SnapKit

final class NewsViewController: UIViewController {
    
    private let tableView = NewsTableView()
    
    var viewModel: NewsViewModelDelegate? {
        didSet {
            tableView.viewModel = viewModel
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}

extension NewsViewController {
    
    private func configureUI() {
        configureTableView()
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

