import UIKit
import SnapKit

final class NewsCell: UITableViewCell {
    
    private var myViewHeightConstraint: NSLayoutConstraint!
    
    private let activityIndicator = UIActivityIndicatorView()
    private let newsImageView = UIImageView()
    private let newsTitleLabel = UILabel()
    private let newsDescriptionLabel = UILabel()
    private let newsDateLabel = UILabel()
    private let newsAuthorLabel = UILabel()

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
        
        if let savedImage = LocalFileManager.shared.getImage(urlToArticle: article.url ?? "", folderName: "news_images") {
            activityIndicator.stopAnimating()
            newsImageView.image = savedImage
        } else {
            viewModel?.fetchNewsImage(for: article)
        }
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
    }

    private func configureSelf() {
        selectionStyle = .none
    }

    private func configureActivityIndicator() {
        addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints { make in
            make.top.equalTo(self).offset(20)
            make.width.equalTo(UIScreen.main.bounds.width * 0.90)
            make.height.equalTo(150)
            make.centerX.equalTo(self)
        }
    }

    private func configureNewsImageView() {
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.clipsToBounds = true
        newsImageView.layer.cornerRadius = 10

        addSubview(newsImageView)
        newsImageView.snp.makeConstraints { make in
            make.top.equalTo(self).offset(20)
            make.width.equalTo(UIScreen.main.bounds.width * 0.90)
            make.height.equalTo(150)
            make.centerX.equalTo(self)
        }
    }

    private func configureNewsTitleLabel() {
        newsTitleLabel.textAlignment = .left
        newsTitleLabel.textColor = .black
        newsTitleLabel.lineBreakMode = .byWordWrapping
        newsTitleLabel.numberOfLines = 0
        newsTitleLabel.font = .systemFont(ofSize: 25, weight: .bold)

        addSubview(newsTitleLabel)
        newsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(newsImageView.snp.bottom).offset(10)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }
    }
    
    private func configureNewsDescriptionLabel() {
        newsDescriptionLabel.textAlignment = .justified
        newsDescriptionLabel.textColor = .darkGray
        newsDescriptionLabel.lineBreakMode = .byWordWrapping
        newsDescriptionLabel.numberOfLines = 0
        newsDescriptionLabel.font = .systemFont(ofSize: 18, weight: .medium)

        addSubview(newsDescriptionLabel)
        newsDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(newsTitleLabel.snp.bottom).offset(10)
            make.left.equalTo(self).offset(20)
            make.right.equalTo(self).offset(-20)
        }
    }
    
    private func configureNewsDateLabel() {
        newsDateLabel.textAlignment = .left
        newsDateLabel.textColor = .systemGreen
        newsDateLabel.numberOfLines = 1
        newsDateLabel.font = UIFont(name: "SFMono-Regular", size: 15)

        addSubview(newsDateLabel)
        newsDateLabel.snp.makeConstraints { make in
            make.top.equalTo(newsDescriptionLabel.snp.bottom).offset(10)
            make.left.equalTo(self).offset(20)
        }
    }
    
    private func configureNewsAuthorLabel() {
        newsAuthorLabel.textAlignment = .right
        newsAuthorLabel.textColor = .gray
        newsAuthorLabel.numberOfLines = 1
        newsAuthorLabel.font = UIFont(name: "SFMono-Regular", size: 15)

        addSubview(newsAuthorLabel)
        newsAuthorLabel.snp.makeConstraints { make in
            make.top.equalTo(newsDescriptionLabel.snp.bottom).offset(10)
            make.left.equalTo(newsDateLabel.snp.right).offset(10)
            make.bottom.equalTo(self).offset(-1 * 20)
        }
    }
    
    private func getHeight(forImage image: UIImage) -> (CGFloat, CGFloat) {
        let width = UIScreen.main.bounds.width * 0.90
        let targetSize = CGSize(width: width, height: width)

        let widthScaleRatio = targetSize.width / image.size.width
        let heightScaleRatio = targetSize.height / image.size.height

        let scaleFactor = min(widthScaleRatio, heightScaleRatio)

        let scaledImageSize = CGSize(
            width: image.size.width * scaleFactor,
            height: image.size.height * scaleFactor
        )
        
        return (width, scaledImageSize.height)
    }
}

