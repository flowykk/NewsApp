import Foundation

extension Date {

    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy, h:mm a"

        return dateFormatter.string(from: self)
    }
}
