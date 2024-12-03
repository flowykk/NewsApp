import UIKit

final class NewsTableView: UITableView {
    
    var response = NewsResponse()
    
    var viewModel: NewsViewModelDelegate? {
        didSet{
            viewModel?.didFetchedNews = { [weak self] response in
                self?.response = response
                
                DispatchQueue.main.async { [weak self] in
                    self?.reloadData()
                }
            }
            viewModel?.fetchNews(keyword: "putin", page: 1, pageSize: 10)
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        return response.articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "newsCell", for: indexPath) as! NewsCell
        
        let article = response.articles[indexPath.row]
        cell.viewModel = NewsImageViewModel()
        cell.set(with: article)
        
        return cell
    }
}
