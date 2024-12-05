import UIKit

class EmptyLabel: UILabel {

    init(message: String) {
        super.init(frame: .zero)
        self.text = message

        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setMessage(message: String) {
        text = message
    }
}

extension EmptyLabel {

    private func configureUI() {
        textAlignment = .center
        backgroundColor = Colors.backgroundColor
        textColor = Colors.secondaryTextColor
        numberOfLines = 0
        font = .systemFont(ofSize: 18, weight: .medium)
        translatesAutoresizingMaskIntoConstraints = false
    }
}
