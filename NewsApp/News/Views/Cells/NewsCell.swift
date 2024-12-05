import UIKit
import SnapKit

final class NewsCell: UITableViewCell {
    
    private var article: Article?
    private var isFavourite = false
    
    private var myViewHeightConstraint: NSLayoutConstraint!
    
    private let activityIndicator = UIActivityIndicatorView()
    private let newsImageView = UIImageView()
    private let newsTitleLabel = UILabel()
    private let newsDescriptionLabel = UILabel()
    private let newsDateLabel = UILabel()
    private let newsSourceLabel = UILabel()
    private let favouriteButton = UIButton()

    var viewModel: NewsImageViewModelDelegate? {
        didSet {
            newsImageView.image = nil
            activityIndicator.startAnimating()
            viewModel?.didFetchedNewsImage = { [weak self] image in
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                    
                    self?.newsImageView.image = image
                    self?.newsImageView.snp.makeConstraints { make in
                        make.height.equalTo(150)
                    }
                }
            }
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        newsImageView.image = nil
    }

    func set(with article: Article) {
        self.article = article
        
        newsTitleLabel.text = article.title
        newsDescriptionLabel.text = article.description
        newsDateLabel.text = article.publishedAt?.toFormattedDate()
        newsSourceLabel.text = "/ " + (article.source?.name ?? "no source")
        
        guard let urlToImageString = article.urlToImage,
              let _ = URL(string: urlToImageString)
        else {
            activityIndicator.stopAnimating()
            newsImageView.image = UIImage(named: "placeholder")
                
            return
        }
        
        guard let urlToArticle = article.url else { return }
        if let savedImage = LocalFileManager.shared.getImage(urlToArticle: urlToArticle, folderName: "news_images") {
            activityIndicator.stopAnimating()
            newsImageView.image = savedImage
        } else {
            viewModel?.fetchNewsImage(for: article)
        }
        
        ArticlesDatabaseManager.shared.articleExists(withUrl: article.url ?? " ") { [weak self] exists in
            self?.isFavourite = exists
            self?.favouriteButton.setImage(self?.getImage(), for: .normal)
            
            self?.favouriteButton.tintColor = exists ? Colors.starColor : Colors.tertiaryTextColor
        }
    }
}

extension NewsCell {
    
    @objc
    private func favouriteButtonTapped() {
        guard let article else { return }
        let articleDTO = ArticleDTO(
            url: article.url ?? "",
            sourceName: article.source?.name ?? "",
            title: article.title ?? "",
            articleDescription: article.description ?? "",
            urlToImage: article.urlToImage ?? "",
            publishedAt: article.publishedAt ?? ""
        )
        
        if isFavourite {
            ArticlesDatabaseManager.shared.removeArticle(article: articleDTO)
        } else {
            ArticlesDatabaseManager.shared.saveArticle(article: articleDTO)
        }
        
        isFavourite.toggle()
        favouriteButton.setImage(getImage(), for: .normal)
        favouriteButton.tintColor = isFavourite ? Colors.starColor : Colors.tertiaryTextColor
    }
    
    private func getImage() -> UIImage {
        let largeFont = UIFont.systemFont(ofSize: 22, weight: .medium)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        
        var image: UIImage = UIImage()
        if isFavourite {
            image = UIImage(systemName: "star.fill", withConfiguration: configuration)!
        } else {
            image = UIImage(systemName: "star", withConfiguration: configuration)!
        }
        
        return image
    }
}

extension NewsCell {
    
    private func configureUI() {
        configureSelf()
        
        configureActivityIndicator()
        configureNewsImageView()
        
        configureNewsTitleLabel()
        configureNewsDescriptionLabel()
        configureNewsDateLabel()
        configureNewsSourceLabel()
        configureFavouriteButton()
    }
    
    private func configureSelf() {
        backgroundColor = Colors.backgroundColor
        selectionStyle = .none
    }
    
    private func configureActivityIndicator() {
        contentView.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.width.equalTo(UIScreen.main.bounds.width * 0.90)
            make.height.equalTo(150)
            make.centerX.equalTo(contentView)
        }
    }
    
    private func configureNewsImageView() {
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.clipsToBounds = true
        newsImageView.layer.cornerRadius = 10
        
        contentView.addSubview(newsImageView)
        newsImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(20)
            make.width.equalTo(UIScreen.main.bounds.width * 0.90)
            make.height.equalTo(150)
            make.centerX.equalTo(contentView)
        }
    }
    
    private func configureNewsTitleLabel() {
        newsTitleLabel.textAlignment = .left
        newsTitleLabel.textColor = Colors.primaryTextColor
        newsTitleLabel.lineBreakMode = .byWordWrapping
        newsTitleLabel.numberOfLines = 0
        newsTitleLabel.font = .systemFont(ofSize: 25, weight: .bold)
        
        contentView.addSubview(newsTitleLabel)
        newsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(newsImageView.snp.bottom).offset(10)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
        }
    }
    
    private func configureNewsDescriptionLabel() {
        newsDescriptionLabel.textAlignment = .justified
        newsDescriptionLabel.textColor = Colors.secondaryTextColor
        newsDescriptionLabel.lineBreakMode = .byWordWrapping
        newsDescriptionLabel.numberOfLines = 0
        newsDescriptionLabel.font = .systemFont(ofSize: 18, weight: .regular)
        
        contentView.addSubview(newsDescriptionLabel)
        newsDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(newsTitleLabel.snp.bottom).offset(15)
            make.left.equalTo(contentView).offset(20)
            make.right.equalTo(contentView).offset(-20)
        }
    }
    
    private func configureNewsDateLabel() {
        newsDateLabel.textAlignment = .left
        newsDateLabel.textColor = Colors.additionalTextColor
        newsDateLabel.numberOfLines = 1
        newsDateLabel.font = UIFont(name: "SFMono-Regular", size: 15)
        
        contentView.addSubview(newsDateLabel)
        newsDateLabel.snp.makeConstraints { make in
            make.top.equalTo(newsDescriptionLabel.snp.bottom).offset(15)
            make.left.equalTo(contentView).offset(20)
        }
    }
    
    private func configureNewsSourceLabel() {
        newsSourceLabel.textAlignment = .left
        newsSourceLabel.textColor = Colors.tertiaryTextColor
        newsSourceLabel.numberOfLines = 1
        newsSourceLabel.font = UIFont(name: "SFMono-Regular", size: 15)
        
        contentView.addSubview(newsSourceLabel)
        newsSourceLabel.snp.makeConstraints { make in
            make.top.equalTo(newsDescriptionLabel.snp.bottom).offset(15)
            make.width.equalTo(UIScreen.main.bounds.width * 0.42)
            make.left.equalTo(newsDateLabel.snp.right).offset(10)
            make.bottom.equalTo(contentView).offset(-1 * 20)
        }
    }
    
    private func configureFavouriteButton() {
        favouriteButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        
        contentView.addSubview(favouriteButton)
        favouriteButton.snp.makeConstraints { make in
            make.bottom.equalTo(contentView).offset(-1 * 18)
            make.right.equalTo(contentView).offset(-1 * 20)
        }
    }
}
