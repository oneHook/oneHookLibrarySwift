import UIKit

extension NSAttributedString {
    
    public static func join(values: [NSAttributedString],
                            seperator: NSAttributedString,
                            lineSpacing: CGFloat? = nil,
                            textAlignment: NSTextAlignment = .left) -> NSAttributedString? {
        if values.isEmpty {
            return nil
        }
        if values.count == 1 {
            return values.first
        }
        let retVal = NSMutableAttributedString()
        for index in 0..<values.count - 1 {
            retVal.append(values[index])
            retVal.append(seperator)
        }
        retVal.append(values.last!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = textAlignment
        if let lineSpacing = lineSpacing {
            paragraphStyle.lineSpacing = lineSpacing
        }
        retVal.addAttribute(NSAttributedString.Key.paragraphStyle,
                            value: paragraphStyle,
                            range: NSRange(location: 0, length: retVal.length))
        return retVal
    }


    public func attributedString(lineSpacing: CGFloat = 0,
                                 letterSpacing: CGFloat? = nil,
                                 hasUnderline: Bool = false,
                                 textAlignment: NSTextAlignment = .left,
                                 font: UIFont? = nil,
                                 textColor: UIColor? = nil,
                                 lineBreakMode: NSLineBreakMode? = nil) -> NSMutableAttributedString {
        let retVal = NSMutableAttributedString(attributedString: self)

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = textAlignment
        if let lineBreakMode = lineBreakMode {
            paragraphStyle.lineBreakMode = lineBreakMode
        }
        retVal.addAttribute(.paragraphStyle,
                            value: paragraphStyle,
                            range: NSRange(location: 0, length: retVal.length))

        if hasUnderline {
            retVal.addAttribute(.underlineStyle,
                                value: NSUnderlineStyle.single.rawValue,
                                range: NSRange(location: 0, length: retVal.length))
        }

        if let letterSpacing = letterSpacing {
            retVal.addAttribute(.kern,
                                value: letterSpacing,
                                range: NSRange(location: 0, length: retVal.length))
        }

        if let font = font {
            retVal.addAttribute(.font,
                                value: font,
                                range: NSRange(location: 0, length: retVal.length))
        }

        if let textColor = textColor {
            retVal.addAttribute(.foregroundColor,
                                value: textColor,
                                range: NSRange(location: 0, length: retVal.length))
        }

        return retVal
    }
}
