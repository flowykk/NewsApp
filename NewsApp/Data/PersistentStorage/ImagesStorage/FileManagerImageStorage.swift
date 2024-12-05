import UIKit

protocol LocalFileManagerProtocol {

    func saveImage(image: UIImage, urlToArticle: String, folderName: String)
    func getImage(urlToArticle: String, folderName: String) -> UIImage?
    func deleteImage(urlToArticle: String, folderName: String)
}

final class FileManagerImageStorage: LocalFileManagerProtocol {

    static let shared = FileManagerImageStorage()

    private init() { }

    func saveImage(image: UIImage, urlToArticle: String, folderName: String) {
        let imageName = urlToArticle.replacingOccurrences(of: "/", with: "_")
        createFolderIfNeeded(folderName: folderName)

        guard
            let data = image.pngData(),
            let url = getURLForImage(urlToArticle: imageName, folderName: folderName)
            else { return }

        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving image: \(imageName). \(error)")
        }
    }

    func getImage(urlToArticle: String, folderName: String) -> UIImage? {
        let imageName = urlToArticle.replacingOccurrences(of: "/", with: "_")
        guard let url = getURLForImage(urlToArticle: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {
            return nil
        }
        return UIImage(contentsOfFile: url.path)
    }

    func deleteImage(urlToArticle: String, folderName: String) {
        let imageName = urlToArticle.replacingOccurrences(of: "/", with: "_")
        guard let url = getURLForImage(urlToArticle: imageName, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path) else {
            return
        }

        do {
            try FileManager.default.removeItem(at: url)
        } catch let error {
            print("Error deleting image: \(folderName). \(error)")
        }
    }
}

extension FileManagerImageStorage {
    private func createFolderIfNeeded(folderName: String) {
        guard let url = getURLForFolder(folderName: folderName) else { return }

        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error creating directory: \(folderName). \(error)")
            }
        }
    }

    private func getURLForFolder(folderName: String) -> URL? {
        guard let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }
        return url.appendingPathComponent(folderName)
    }

    private func getURLForImage(urlToArticle: String, folderName: String) -> URL? {
        let imageName = urlToArticle.replacingOccurrences(of: "/", with: "_")
        guard let folderURL = getURLForFolder(folderName: folderName) else {
            return nil
        }
        return folderURL.appendingPathComponent(imageName + ".png")
    }
}
