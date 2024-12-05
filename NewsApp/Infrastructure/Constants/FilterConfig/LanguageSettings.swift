enum LanguageSettings: String, CaseIterable {

    case russian = "Russian"
    case english = "English"
    case german = "German"
    case french = "French"
    case italian = "Italian"
    case resetSettings = "Reset filter"

    func getCode() -> String {
        switch self {
        case .russian: return "ru"
        case .english: return "en"
        case .german: return "de"
        case .french: return "fr"
        case .italian: return "it"
        default: return "none"
        }
    }
}
