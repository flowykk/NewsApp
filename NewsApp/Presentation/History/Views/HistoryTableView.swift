import UIKit

protocol HistoryTableViewDelegate: AnyObject {
    
    func didDeleteRow(with search: SearchHistoryItem)
}

final class HistoryTableView: UITableView {
    
    weak var customDelegate: HistoryTableViewDelegate?
    
    var history: [SearchHistoryItem] = []
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(with history: [SearchHistoryItem]) {
        self.history = history
        
        DispatchQueue.main.async { [weak self] in
            self?.reloadData()
        }
    }
    
    private func commonInit() {
        backgroundColor = Colors.backgroundColor
        delegate = self
        dataSource = self
        register(HistoryCell.self , forCellReuseIdentifier: "historyCell")
        
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 50
    }
}

extension HistoryTableView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return history.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! HistoryCell
        
        let item = history[indexPath.row]
        cell.set(with: item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            customDelegate?.didDeleteRow(with: history[indexPath.row])
            history.remove(at: indexPath.row)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
