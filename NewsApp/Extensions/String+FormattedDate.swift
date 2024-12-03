import Foundation
import UIKit

extension String {
    func toFormattedDate() -> String? {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = [.withInternetDateTime]

        if let date = isoDateFormatter.date(from: self) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "M/dd/yy, h:mm a"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")

            return dateFormatter.string(from: date)
        } else {
            return nil
        }
    }
}
