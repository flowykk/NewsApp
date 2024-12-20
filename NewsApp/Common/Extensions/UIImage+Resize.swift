import UIKit
import AVFoundation

extension UIImage {

    convenience init?(base64String: String) {
        guard let imageData = Data(base64Encoded: base64String) else {
            return nil
        }
        self.init(data: imageData)
    }

    func resize(toDimension dimension: Int) -> UIImage {
        var targetSize = CGSize(width: dimension, height: dimension)

        let widthScaleRatio = targetSize.width / self.size.width
        let heightScaleRatio = targetSize.height / self.size.height

        let scaleFactor = min(widthScaleRatio, heightScaleRatio)
        let scaledImageSize = CGSize(width: self.size.width * scaleFactor, height: self.size.height * scaleFactor)

        let newWidth = Int(scaledImageSize.width)
        let newHeight = Int(scaledImageSize.height)

        let maxSize = CGSize(width: newWidth, height: newHeight)
        let availableRect = AVFoundation.AVMakeRect(
            aspectRatio: self.size,
            insideRect: .init(origin: .zero, size: maxSize)
        )

        targetSize = availableRect.size

        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)

        let resized = renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }

        return resized
    }
}
