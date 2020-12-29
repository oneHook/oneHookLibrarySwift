import UIKit

extension UIDevice {
    public var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else {
                return identifier
            }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        // Data from https://www.theiphonewiki.com/wiki/Models
        switch identifier {

        // iPhones.
        case "iPhone1,1":                  return "iPhone 1G"
        case "iPhone1,2":                  return "iPhone 3G"
        case "iPhone2,1":                  return "iPhone 3GS"
        case "iPhone3,1":                  return "iPhone 4"
        case "iPhone3,2":                  return "iPhone 4 CDMA"
        case "iPhone3,3":                  return "Verizon iPhone 4"
        case "iPhone4,1":                  return "iPhone 4S"
        case "iPhone5,1":                  return "iPhone 5 (GSM)"
        case "iPhone5,2":                  return "iPhone 5 (GSM+CDMA)"
        case "iPhone5,3":                  return "iPhone 5c (GSM)"
        case "iPhone5,4":                  return "iPhone 5c (GSM+CDMA)"
        case "iPhone6,1":                  return "iPhone 5s (GSM)"
        case "iPhone6,2":                  return "iPhone 5s (GSM+CDMA)"
        case "iPhone7,2":                  return "iPhone 6"
        case "iPhone7,1":                  return "iPhone 6 Plus"
        case "iPhone8,1":                  return "iPhone 6s"
        case "iPhone8,2":                  return "iPhone 6s Plus"
        case "iPhone8,4":                  return "iPhone SE"
        case "iPhone9,1", "iPhone9,3":     return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":     return "iPhone 7 Plus"
        case "iPhone10,1", "iPhone10,4":   return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":   return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":   return "iPhone X"
        case "iPhone11,2":                 return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":   return "iPhone XS Max"
        case "iPhone11,8":                 return "iPhone XR"

        // iPods.
        case "iPod1,1": return "iPod Touch 1G"
        case "iPod2,1": return "iPod Touch 2G"
        case "iPod3,1": return "iPod Touch 3G"
        case "iPod4,1": return "iPod Touch 4G"
        case "iPod5,1": return "iPod Touch 5G"
        case "iPod7,1": return "iPod Touch 6G"

        // iPads.
        case "iPad1,1":            return "iPad"
        case "iPad2,1", "iPad2,4": return "iPad 2 (WiFi)"
        case "iPad2,2", "iPad2,3": return "iPad 2 (Cellular)"
        case "iPad3,1", "iPad3,4": return "iPad 3 (WiFi)"
        case "iPad3,2", "iPad3,3": return "iPad 3 (Cellular)"
        case "iPad3,5", "iPad3,6": return "iPad 4 (Cellular)"
        case "iPad4,1", "iPad4,3": return "iPad Air (WiFi)"
        case "iPad4,2":            return "iPad Air (Cellular)"
        case "iPad5,3":            return "iPad Air 2 (WiFi)"
        case "iPad5,4":            return "iPad Air 2 (Cellular)"
        case "iPad6,7":            return "iPad Pro (12.9 inch) (WiFi)"
        case "iPad6,8":            return "iPad Pro (12.9 inch) (Cellular)"
        case "iPad6,3":            return "iPad Pro (9.7 inch) (Wifi)"
        case "iPad6,4":            return "iPad Pro (9.7 inch) (Cellular)"
        case "iPad6,11":            return "iPad (5th generation) (Wifi)"
        case "iPad6,12":            return "iPad (5th generation) (Cellular)"
        case "iPad7,1":            return "iPad Pro (12.9-inch, 2nd generation) (Wifi)"
        case "iPad7,2":            return "iPad Pro (12.9-inch, 2nd generation) (Cellular)"
        case "iPad7,3":            return "iPad Pro (10.5-inch) (Wifi)"
        case "iPad7,4":            return "iPad Pro (10.5-inch) (Cellular)"

        // iPads (Mini).
        case "iPad2,5":            return "iPad Mini (WiFi)"
        case "iPad2,6", "iPad2,7": return "iPad Mini (Cellular)"
        case "iPad4,4":            return "iPad Mini 2 (Wifi)"
        case "iPad4,5", "iPad4,6": return "iPad Mini 2 (Cellular)"
        case "iPad4,7":            return "iPad Mini 3 (Wifi)"
        case "iPad4,8", "iPad4,9": return "iPad Mini 3 (Cellular)"
        case "iPad5,1":            return "iPad Mini 4 (Wifi)"
        case "iPad5,2":            return "iPad Mini 4 (Cellular)"

        // Others.
        case "AppleTV5,3":     return "Apple TV 4"
        case "i386", "x86_64": return "Simulator"
        default:               return identifier
        }
    }

    public var osName: String {
        #if os(iOS)
            return "iOS"
        #elseif os(watchOS)
            return "watchOS"
        #elseif os(tvOS)
            return "tvOS"
        #else
            return "Unknown"
        #endif
    }

    public var appVersion: String { // swiftlint:disable:next force_cast
        return Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    }

    public var appBuild: String { // swiftlint:disable:next force_cast
        return Bundle.main.infoDictionary!["CFBundleVersion"] as! String
    }

    public var userAgent: String {
        let appName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
        // swiftlint:disable:previous force_cast
        let deviceType = UIDevice.current.modelName
        let osName = UIDevice.current.osName
        let osVersion = UIDevice.current.systemVersion
        return "\(appName) \(appVersion) (\(appBuild)) - \(deviceType) - \(osName) \(osVersion)"
    }
}

extension UIDevice {

    public var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }
}

extension UIScreen {

    public static var safeArea: UIEdgeInsets {
        UIApplication.shared.delegate?.window??.safeAreaInsets ?? .zero
    }

    public static var statusBarHeight: CGFloat {
        let topSafeArea = UIScreen.safeArea.top
        return max(20, topSafeArea)
    }

    public static var minimumBottomMargin: CGFloat {
        UIScreen.safeArea.bottom
    }

    public static var hasTopNotch: Bool {
        UIScreen.safeArea.top > 20
    }

    public static var hasRoundedCorners: Bool {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.delegate?.window??.safeAreaInsets.bottom ?? 0 > 0
        } else {
            return false
        }
    }
}

extension Bundle {

    public var versionNumber: String {
        (self.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "N/A"
    }

    public var buildNumber: String {
        (self.infoDictionary?["CFBundleVersion"] as? String) ?? "N/A"
    }
}
