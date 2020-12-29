public class NumberUtility {
    public static var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = LocalizationManager.shared.locale
        formatter.maximumFractionDigits = 0
        return formatter
    }

    public static var decimalFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = LocalizationManager.shared.locale
        formatter.maximumFractionDigits = 2
        return formatter
    }

    public static var currencyFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = LocalizationManager.shared.locale
        return formatter
    }

    public static var currencyFormatterNoChange: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 0
        formatter.locale = LocalizationManager.shared.locale
        return formatter
    }

    public static var percentFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.maximumFractionDigits = 0
        formatter.locale = LocalizationManager.shared.locale
        return formatter
    }

    public static func formatInt(_ number: Int, unit: String? = nil) -> String {
        formatString(numberFormatter.string(from: NSNumber(value: number)) ?? String(number), unit: unit)
    }

    public static func formatDecimal(_ number: Int, unit: String? = nil) -> String {
        formatString(decimalFormatter.string(from: NSNumber(value: number)) ?? String(number), unit: unit)
    }

    public static func formatCurrency(_ number: Int, unit: String? = nil) -> String {
        formatString(currencyFormatter.string(from: NSNumber(value: number)) ?? String(number), unit: unit)
    }

    public static func formatCurrencyNoChange(_ number: Int, unit: String? = nil) -> String {
        formatString(currencyFormatterNoChange.string(from: NSNumber(value: number)) ?? String(number), unit: unit)
    }

    public static func formatPercent(_ number: Float) -> String {
        percentFormatter.string(from: NSNumber(value: number)) ?? String(number)
    }

    public static func formatString(_ string: String, unit: String? = nil) -> String {
        if let unit = unit {
            return string + " " + unit
        } else {
            return string
        }
    }
}

public extension Float {

    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    static var random: Float {
        Float.random(in: 0...1)
    }

    /// Random float between 0 and n-1.
    ///
    /// - Parameter n:  Interval max
    /// - Returns:      Returns a random float point number between 0 and n max
    static func random(min: Float, max: Float) -> Float {
        Float.random * (max - min) + min
    }
}
