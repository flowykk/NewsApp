import UIKit

final class NewsTableView: UITableView {
    
    var articles: [Article] = []
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(with articles: [Article]) {
        self.articles = articles
        
        DispatchQueue.main.async { [weak self] in
            self?.reloadData()
        }
    }
    
    private func commonInit() {
        delegate = self
        dataSource = self
        register(NewsCell.self , forCellReuseIdentifier: "newsCell")
        
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = 600
    }
}

extension NewsTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsCell
        
        let article = articles[indexPath.row]
        cell.viewModel = NewsImageViewModel()
        cell.set(with: article)
        
        return cell
    }
}
