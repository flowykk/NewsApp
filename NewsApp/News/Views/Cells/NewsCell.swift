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
    private let newsAuthorLabel = UILabel()
    private let favouriteButton = UIButton()

    var viewModel: NewsImageViewModelDelegate? {
        didSet {
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

    func set(with article: Article) {
        self.article = article
        
        newsTitleLabel.text = article.title
        newsDescriptionLabel.text = article.description
        newsDateLabel.text = article.publishedAt?.toFormattedDate()
        newsAuthorLabel.text = "/ " + (article.source?.name ?? "no source")
        
        guard let urlToImageString = article.urlToImage,
              let _ = URL(string: urlToImageString)
        else {
            activityIndicator.stopAnimating()
            
            newsImageView.image = UIImage(named: "placeholder")
            
//            newsImageView.image = nil
//            newsImageView.snp.makeConstraints { make in
//                make.height.equalTo(0)
//            }
//            newsTitleLabel.snp.makeConstraints { make in
//                make.top.equalTo(self).offset(15)
//            }
                
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
            
            if exists {
                self?.favouriteButton.tintColor = .systemYellow
            } else {
                self?.favouriteButton.tintColor = .darkGray
            }
        }
    }
}

extension NewsCell {
    
    @objc
    private func favouriteButtonTapped() {
        print("favvv <3")
        
        guard let article else { return }
        ArticlesDatabaseManager.shared.saveArticle(
            article: ArticleDTO(
                url: article.url ?? "",
                sourceName: article.source?.name ?? "",
                title: article.title ?? "",
                articleDescription: article.description ?? "",
                urlToImage: article.urlToImage ?? "",
                publishedAt: article.publishedAt ?? ""
            )
        )
        
        isFavourite.toggle()
        favouriteButton.setImage(getImage(), for: .normal)
        favouriteButton.tintColor = isFavourite ? .systemYellow : .darkGray
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
        configureNewsAuthorLabel()
        configureFavouriteButton()
    }
    
    private func configureSelf() {
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
        newsTitleLabel.textColor = .black
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
        newsDescriptionLabel.textColor = .darkGray
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
        newsDateLabel.textColor = .systemGreen
        newsDateLabel.numberOfLines = 1
        newsDateLabel.font = UIFont(name: "SFMono-Regular", size: 15)
        
        contentView.addSubview(newsDateLabel)
        newsDateLabel.snp.makeConstraints { make in
            make.top.equalTo(newsDescriptionLabel.snp.bottom).offset(15)
            make.left.equalTo(contentView).offset(20)
        }
    }
    
    private func configureNewsAuthorLabel() {
        newsAuthorLabel.textAlignment = .right
        newsAuthorLabel.textColor = .gray
        newsAuthorLabel.numberOfLines = 1
        newsAuthorLabel.font = UIFont(name: "SFMono-Regular", size: 15)
        
        contentView.addSubview(newsAuthorLabel)
        newsAuthorLabel.snp.makeConstraints { make in
            make.top.equalTo(newsDescriptionLabel.snp.bottom).offset(15)
            make.left.equalTo(newsDateLabel.snp.right).offset(10)
            make.bottom.equalTo(contentView).offset(-1 * 20)
        }
    }
    
    private func configureFavouriteButton() {
        let largeFont = UIFont.systemFont(ofSize: 22, weight: .medium)
        let configuration = UIImage.SymbolConfiguration(font: largeFont)
        let image = UIImage(systemName: "star", withConfiguration: configuration)!
        
        favouriteButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        
        contentView.addSubview(favouriteButton)
        favouriteButton.snp.makeConstraints { make in
            make.bottom.equalTo(contentView).offset(-1 * 18)
            make.right.equalTo(contentView).offset(-1 * 20)
        }
    }
}
