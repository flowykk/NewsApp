import UIKit
import SnapKit

final class HistoryViewController: UIViewController {
    
    var viewModel: HistoryViewModelDelegate? {
        didSet {
            viewModel?.didFetchedHistory = { history in // [weak self]
                print(history)
            }
            viewModel?.fetchHistory()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .red
    }
}
