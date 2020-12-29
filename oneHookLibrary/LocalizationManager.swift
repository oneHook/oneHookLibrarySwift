import UIKit

// missing string not found in Lokalise
public func missing(_ key: String, comment: String) -> String {
    comment
}

public func missing(_ comment: String) -> String {
    comment
}


public class LocalizationManager {
    public static let shared = LocalizationManager()

    private var customLocale: Locale?

    public var locale: Locale {
//        if let customLocale = customLocale {
//            return customLocale
//        } else if let savedLocaleIdentifier = UserDefaults.eDealer.string(forKey: "localKey") {
//            let locale = Locale(identifier: savedLocaleIdentifier)
//            customLocale = locale
//            return locale
//        } else {
//            return Locale.current
//        }
        Locale.current
    }

    @discardableResult
    public func updateLocale(_ id: String) -> Bool {
        guard locale.identifier != id else {
            return false
        }

        customLocale = Locale(identifier: id)
        return true
    }
}
