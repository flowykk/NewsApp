import UIKit
import SnapKit

final class HistoryCell: UITableViewCell {
    
    private let searchTitleLabel = UILabel()
    private let searchResultsLabel = UILabel()
    private let searchTimeLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(with historyItem: SearchHistoryItem) {
        searchTitleLabel.text = historyItem.title
        searchResultsLabel.text = historyItem.totalResults
        print(historyItem.searchDate)
        searchTimeLabel.text = historyItem.searchDate
    }
}

extension HistoryCell {
    
    private func configureUI() {
        configureSelf()
        
        configureSearchTitleLabel()
        configureSearchResultsLabel()
        configureSearchDateLabel()
    }
    
    private func configureSelf() {
        selectionStyle = .none
    }
    
    private func configureSearchTitleLabel() {
        searchTitleLabel.textAlignment = .left
        searchTitleLabel.textColor = .black
        searchTitleLabel.numberOfLines = 1
        searchTitleLabel.font = .systemFont(ofSize: 16, weight: .semibold)

        addSubview(searchTitleLabel)
        searchTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(7)
            make.left.equalTo(self).offset(20)
            make.width.equalTo(UIScreen.main.bounds.width * 0.6)
        }
    }
    
    private func configureSearchResultsLabel() {
        searchResultsLabel.textAlignment = .right
        searchResultsLabel.textColor = .gray
        searchResultsLabel.numberOfLines = 1
        searchResultsLabel.font = .systemFont(ofSize: 15, weight: .medium)

        addSubview(searchResultsLabel)
        searchResultsLabel.snp.makeConstraints { make in
            make.top.equalTo(self).offset(7)
            make.right.equalTo(self).offset(-20)
        }
    }
    
    private func configureSearchDateLabel() {
        searchTimeLabel.textAlignment = .left
        searchTimeLabel.textColor = .gray
        searchTimeLabel.numberOfLines = 1
        searchTimeLabel.font = UIFont(name: "SFMono-Regular", size: 13)

        addSubview(searchTimeLabel)
        searchTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(searchTitleLabel.snp.bottom).offset(2)
            make.left.equalTo(self).offset(20)
            make.bottom.equalTo(self).offset(-7)
        }
    }
}
