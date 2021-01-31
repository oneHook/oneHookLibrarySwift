import UIKit

extension String {
    
    public func formatPhoneNumber(keepCountryCode: Bool = true) -> String {
        String.format(phoneNumber: self, keepCountryCode: keepCountryCode)
    }

    public static func format(phoneNumber sourcePhoneNumber: String, keepCountryCode: Bool = true) -> String {
        // Remove any character that is not a number
        let numbersOnly = sourcePhoneNumber.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
        let hasLeadingOne = numbersOnly.hasPrefix("1")

        var sourceIndex = 0

        // Leading 1
        var leadingOne = ""
        if hasLeadingOne {
            if keepCountryCode {
                leadingOne = "1 "
            }
            sourceIndex += 1
        }

        // Area code
        var areaCode = ""
        let areaCodeLength = 3
        guard let areaCodeSubstring = numbersOnly.substring(start: sourceIndex,
                                                            offsetBy: areaCodeLength) else {
            return sourcePhoneNumber
        }
        areaCode = String(format: "(%@) ", areaCodeSubstring)
        sourceIndex += areaCodeLength

        // Prefix, 3 characters
        let prefixLength = 3
        guard let prefix = numbersOnly.substring(start: sourceIndex, offsetBy: prefixLength) else {
            return numbersOnly
        }
        sourceIndex += prefixLength

        // Suffix, 4 characters
        let suffixLength = 4
        guard let suffix = numbersOnly.substring(start: sourceIndex,
                                                 offsetBy: suffixLength) else {
            return leadingOne + areaCode + prefix
        }
        return leadingOne + areaCode + prefix + "-" + suffix
    }

    internal func substring(start: Int, offsetBy: Int) -> String? {
        guard let substringStartIndex = self.index(startIndex,
                                                   offsetBy: start,
                                                   limitedBy: endIndex) else {
            return nil
        }

        guard let substringEndIndex = self.index(startIndex,
                                                 offsetBy: start + offsetBy,
                                                 limitedBy: endIndex) else {
            let result = String(self[substringStartIndex ..< self.endIndex])
            return result.isEmpty ? nil : result
        }

        return String(self[substringStartIndex ..< substringEndIndex])
    }

    public subscript (i: Int) -> Character {
        self[index(startIndex, offsetBy: i)]
    }

    public subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ..< end]
    }

    public subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ... end]
    }

    public subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        return self[start ... end]
    }

    public subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ... end]
    }

    public subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ..< end]
    }

    public func attributedString(lineSpacing: CGFloat = 0,
                                 letterSpacing: CGFloat? = nil,
                                 hasUnderline: Bool = false,
                                 textAlignment: NSTextAlignment = .left,
                                 font: UIFont? = nil,
                                 textColor: UIColor? = nil,
                                 lineBreakMode: NSLineBreakMode? = nil) -> NSMutableAttributedString {
        NSAttributedString(string: self).attributedString(lineSpacing: lineSpacing,
                                                          letterSpacing: letterSpacing,
                                                          hasUnderline: hasUnderline,
                                                          textAlignment: textAlignment,
                                                          font: font,
                                                          textColor: textColor,
                                                          lineBreakMode: lineBreakMode)
    }

    public var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }

    public var isValidPhoneNumber: Bool {
        let isDigit = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
        return isDigit && self.count > 0 && ((self[0].description != "1" && self.count == 10) || (self[0].description == "1" && self.count == 11))
    }

    public func removeNonDigits() -> String {
        String(unicodeScalars.filter { CharacterSet.decimalDigits.contains($0) })
    }

    public static func joinStrings(_ value: String?..., seperator: String = " ") -> String? {
        value.reduce("") {
            ($0) + seperator + ($1 ?? "")
        }.trimmingCharacters(in: CharacterSet(charactersIn: seperator) )
    }

    public static func joinStrings(values: [String?], seperator: String = " ") -> String? {
        values.reduce("") {
            if let next = $1, next.isNotEmpty {
                return ($0) + seperator + next
            } else {
                return $0
            }
        }.trimmingCharacters(in: CharacterSet(charactersIn: seperator) )
    }

    public func versionToInt() -> [Int]? {
        var didFail = false
        let result = components(separatedBy: ".").map { Int($0) ?? { didFail = true; return 0 }() }

        if didFail {
            return nil
        }

        return result
    }

    public func toBase64() -> String {
        Data(self.utf8).base64EncodedString()
    }

    public func toJSON() -> Any? {
        guard let data = data(using: .utf8, allowLossyConversion: false) else { return nil }
        return try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)
    }
}

extension Character {
    public static func joinCharacters(_ value: Character?..., seperator: String = " ") -> String? {
        value.reduce("") {
            ($0) + seperator + ($1 != nil ? String($1!) : "")
        }.trimmingCharacters(in: CharacterSet(charactersIn: seperator) )
    }
}

extension Substring {
    subscript (i: Int) -> Character {
        self[index(startIndex, offsetBy: i)]
    }
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ..< end]
    }
    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start ... end]
    }
    subscript (bounds: CountablePartialRangeFrom<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(endIndex, offsetBy: -1)
        return self[start ... end]
    }
    subscript (bounds: PartialRangeThrough<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ... end]
    }
    subscript (bounds: PartialRangeUpTo<Int>) -> Substring {
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[startIndex ..< end]
    }
}
