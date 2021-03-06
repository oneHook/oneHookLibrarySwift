import UIKit

private var lightTrait: UITraitCollection?
private var darkTrait: UITraitCollection?

extension UIColor {

    /// Note this function can only blend colors found in current trait
    public static func blend(_ colors: UIColor...) -> UIColor {
        let componentsSum = colors.reduce((red: CGFloat(0), green: CGFloat(0), blue: CGFloat(0))) { (temp, color) in
            guard let components = color.cgColor.components else { return temp }
            return (temp.0 + components[0], temp.1 + components[1], temp.2 + components[2])
        }
        let components = (red: componentsSum.red / CGFloat(colors.count) ,
                          green: componentsSum.green / CGFloat(colors.count),
                          blue: componentsSum.blue / CGFloat(colors.count))
        return UIColor(red: components.red, green: components.green, blue: components.blue, alpha: 1)
    }

    public func lighter(by percentage: CGFloat = 30.0, alpha: CGFloat = 1) -> UIColor {
        if #available(iOS 13.0, *) {
            if lightTrait == nil || darkTrait == nil {
                lightTrait = UITraitCollection(userInterfaceStyle: .light)
                darkTrait = UITraitCollection(userInterfaceStyle: .dark)
            }
            let lightColor = resolvedColor(with: lightTrait!)
            let darkColor = resolvedColor(with: darkTrait!)
            return UIColor.dynamic(light: lightColor.adjust(by: abs(percentage), alpha: alpha),
                                   dark: darkColor.adjust(by: -abs(percentage), alpha: alpha))
        } else {
            return self.adjust(by: abs(percentage), alpha: alpha)
        }
    }

    public func darker(by percentage: CGFloat = 30.0, alpha: CGFloat = 1) -> UIColor {
        if #available(iOS 13.0, *) {
            if lightTrait == nil || darkTrait == nil {
                lightTrait = UITraitCollection(userInterfaceStyle: .light)
                darkTrait = UITraitCollection(userInterfaceStyle: .dark)
            }
            let lightColor = resolvedColor(with: lightTrait!)
            let darkColor = resolvedColor(with: darkTrait!)
            return UIColor.dynamic(light: lightColor.adjust(by: -abs(percentage), alpha: alpha),
                                   dark: darkColor.adjust(by: abs(percentage), alpha: alpha))
        } else {
            return self.adjust(by: -abs(percentage), alpha: alpha)
        }
    }

    private func adjust(by percentage: CGFloat = 30.0, alpha: CGFloat = 1) -> UIColor {
        if let components = rgba {
            return UIColor(red: min(components.red + percentage/100, 1.0),
                           green: min(components.green + percentage/100, 1.0),
                           blue: min(components.blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return self
        }
    }

    public static func blend(fromColor fColor: UIColor,
                             toColor tColor: UIColor,
                             step progress: CGFloat = 0.5) -> UIColor {
        if #available(iOS 13.0, *) {
            if lightTrait == nil || darkTrait == nil {
                lightTrait = UITraitCollection(userInterfaceStyle: .light)
                darkTrait = UITraitCollection(userInterfaceStyle: .dark)
            }
            let lightColorFrom = fColor.resolvedColor(with: lightTrait!)
            let darkColorFrom = fColor.resolvedColor(with: darkTrait!)
            let lightColorTo = tColor.resolvedColor(with: lightTrait!)
            let darkColorTo = tColor.resolvedColor(with: darkTrait!)
            return UIColor.dynamic(
                light: blendSingleTrait(fromColor: lightColorFrom, toColor: lightColorTo, step: progress),
                dark: blendSingleTrait(fromColor: darkColorFrom, toColor: darkColorTo, step: progress)
            )
        } else {
            return blendSingleTrait(fromColor: fColor, toColor: tColor, step: progress)
        }
    }

    private static func blendSingleTrait(fromColor fColor: UIColor,
                                         toColor tColor: UIColor,
                                         step progress: CGFloat = 0.5) -> UIColor {
        if
            let frgba = fColor.rgba,
            let trgba = tColor.rgba {
            return UIColor(red: frgba.red * progress + trgba.red * (1 - progress),
                           green: frgba.green * progress + trgba.green * (1 - progress),
                           blue: frgba.blue * progress + trgba.blue * (1 - progress),
                           alpha: frgba.alpha * progress + trgba.alpha * (1 - progress))
        } else {
            return fColor
        }
    }

    public static func from(hex: String?) -> UIColor? {
        if hex == nil {
            return nil
        }
        return UIColor(hex: hex!)
    }

    public convenience init(hex: String) {
        var aHex = hex
        if aHex.starts(with: "#") {
            aHex.remove(at: aHex.startIndex)
        }
        let scanner = Scanner(string: aHex)
        scanner.scanLocation = 0

        var rgbValue: UInt64 = 0

        scanner.scanHexInt64(&rgbValue)

        let red = (rgbValue & 0xff0000) >> 16
        let green = (rgbValue & 0xff00) >> 8
        let blue = rgbValue & 0xff

        self.init(
            red: CGFloat(red) / 0xff,
            green: CGFloat(green) / 0xff,
            blue: CGFloat(blue) / 0xff, alpha: 1
        )
    }

    public static func dynamic(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13.0, *) {
            return UIColor(dynamicProvider: {
                switch $0.userInterfaceStyle {
                case .dark:
                    return dark
                case .light, .unspecified:
                    return light
                @unknown default:
                    assertionFailure("Unknown userInterfaceStyle: \($0.userInterfaceStyle)")
                    return light
                }
            })
        }
        // iOS 12 and earlier
        return light
    }

    public static func random(red: CGFloat = .random(in: 0...1),
                              green: CGFloat = .random(in: 0...1),
                              blue: CGFloat = .random(in: 0...1),
                              alpha: CGFloat = .random(in: 0...1)) -> UIColor {
        UIColor(red: red,
                green: green,
                blue: blue,
                alpha: alpha)
    }

    public static func == (left: UIColor, right: UIColor) -> Bool {
        guard
            let lrgba = left.rgba,
            let rrgba = right.rgba else {
            return false
        }

        return
            lrgba.red == rrgba.red &&
            lrgba.green == rrgba.green &&
            lrgba.blue == rrgba.blue &&
            lrgba.alpha == rrgba.alpha
    }

    //swiftlint:disable:next large_tuple
    var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        if getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return (red, green, blue, alpha)
        } else {
            return nil
        }
    }
}
