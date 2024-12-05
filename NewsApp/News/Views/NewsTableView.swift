import UIKit

protocol NewsTableViewDelegate: AnyObject {
    
    func didSelectRow(with article: Article)
    func didScrolledToBottom()
}

final class NewsTableView: UITableView {
    
    weak var customDelegate: NewsTableViewDelegate?
    
    var articles: [Article] = []
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(with articles: [Article]) {
        self.articles.append(contentsOf: articles)
        
        DispatchQueue.main.async { [weak self] in
            self?.reloadData()
        }
    }
    
    func clearData() {
        self.articles = []
    }
    
    private func commonInit() {
        backgroundColor = Colors.backgroundColor
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        customDelegate?.didSelectRow(with: articles[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row >= articles.count - 4 {
            customDelegate?.didScrolledToBottom()
        }
    }
}
