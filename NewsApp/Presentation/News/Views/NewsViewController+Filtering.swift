import UIKit

extension NewsViewController {

    private func performSearch(sortBy: String? = nil, language: String? = nil, needToSave: Bool) {
        tableView.clearData()
        viewModel?.resetCurrentPage()
        guard let searchText = searchText else { return }
        viewModel?.fetchNews(
            keyword: searchText,
            sortBy: sortBy,
            language: language?.getLanguageCode(),
            needToSave: needToSave
        )
    }

    private func updateParameters(languageParameter: String? = nil, sortParameter: String? = nil) {
        self.languageParameter.accept(languageParameter)
        self.sortParameter.accept(sortParameter)
    }

    private func filterTable(sortBy: String? = nil, language: String? = nil) {
        updateParameters(languageParameter: language, sortParameter: sortBy)
        performSearch(
            sortBy: sortParameter.value,
            language: languageParameter.value,
            needToSave: false
        )
    }

    private func resetSort(for variation: FilterVariations) {
        if variation == FilterVariations.language {
            updateParameters(languageParameter: nil, sortParameter: sortParameter.value)
        } else {
            updateParameters(languageParameter: languageParameter.value, sortParameter: nil)
        }

        performSearch(
            sortBy: sortParameter.value,
            language: languageParameter.value,
            needToSave: false
        )
    }

    internal func handleNewSearch() {
        updateParameters()
        performSearch(needToSave: true)
    }

    internal func prepareAlertActions(withVariation variation: FilterVariations) -> [UIAlertAction] {
        var actions = [UIAlertAction]()
        let sortParameters = variation == FilterVariations.language ?
            LanguageSettings.allCases.map { $0.rawValue } :
            FilterSettings.allCases.map { $0.rawValue }

        for parameter in sortParameters {
            let capitalizedParameter = parameter.prefix(1).capitalized + parameter.dropFirst()
            let action = UIAlertAction(title: capitalizedParameter, style: .default) { [unowned self] _ in
                if parameter == "Reset filter" {
                    self.resetSort(for: variation)
                } else {
                    if variation == FilterVariations.language {
                        self.filterTable(sortBy: sortParameter.value, language: parameter)
                    } else {
                        self.filterTable(sortBy: parameter, language: languageParameter.value)
                    }
                }
            }
            actions.append(action)
        }

        actions.append(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        return actions
    }
}
