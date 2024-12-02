import Foundation
import UIKit
import NetworkKit

protocol NewsImageViewModelDelegate {
    
    var image: UIImage? { get set }
    var didFetchedNewsImage: ((UIImage) -> Void)? { get set}
    
    func fetchNewsImage(for imageURL: String)
}

final class NewsImageViewModel: NewsImageViewModelDelegate {
    
    var image: UIImage? {
        didSet {
            didFetchedNewsImage?(image ?? UIImage(named: "placeholder")!)
        }
    }
    var didFetchedNewsImage: ((UIImage) -> Void)?
    
    func fetchNewsImage(for imageURL: String) {
        NetworkManager.shared.fetchNewsImage(for: imageURL) { result in
            switch result {
            case .success(let data):
                self.image = UIImage(data: data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
