import Foundation

extension String {
    func getLanguageCode() -> String {
        guard let language = LanguageSettings(rawValue: self) else { return "" }
        return language.getCode()
    }
}
