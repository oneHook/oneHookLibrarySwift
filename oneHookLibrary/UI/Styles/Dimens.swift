import Foundation
import UIKit

//private let baseFactor: CGFloat = 163  // iPhone 5
//private let usePPIScaling = true
//private let ppiScaling: CGFloat = {
//    guard
//        usePPIScaling,
//        let ppi = GBDeviceInfo.deviceInfo()?.displayInfo.pixelsPerInch,
//        ppi > 0 else {
//            return 1
//    }
//
//    let nativeScale = UIScreen.main.nativeScale
//    let deficeFactor = ppi / nativeScale
//    let scaleFactor = deficeFactor / baseFactor
//
//    return scaleFactor
//}()
//
//private let dimensionScaleHeightThreshold: CGFloat = 667
//#if targetEnvironment(simulator)
//// Approximate factor for simulator, since we don't have ppiScaling, i.e. pixelsPerInch = 0
//private let dimensionScaleFactor: CGFloat = 1.07
//#else
//private let dimensionScaleFactor: CGFloat = 1.1
//#endif
//private let useDimensionScaling = true
//private let dimensionScaling: CGFloat = {
//    guard
//        useDimensionScaling,
//        UIScreen.main.bounds.height > dimensionScaleHeightThreshold else {
//            return 1
//    }
//
//    return dimensionScaleFactor
//}()

//public let devicePixelScale: CGFloat = {
//    ppiScaling * dimensionScaling
//}()

//public func dp(_ value: CGFloat) -> CGFloat { return value * devicePixelScale}


public func dp(_ value: CGFloat) -> CGFloat { return value}

public class Dimens {
    public static var marginXSmall: CGFloat = dp(4)
    public static var marginSmall: CGFloat = dp(5)
    public static var marginMedium: CGFloat = dp(15)
    public static var marginLarge: CGFloat = dp(24)
    public static var marginXLarge: CGFloat = dp(36)
    public static var marginXXLarge: CGFloat = dp(64)
    public static var marginXXXLarge: CGFloat = dp(96)

    private static var defaultToolbarHeight: CGFloat?

    public static var toolbarHeightDefault: CGFloat {
        if Dimens.defaultToolbarHeight == nil {
            if UIDevice.current.isPad {
                Dimens.defaultToolbarHeight = dp(64)
            } else if UIScreen.hasTopNotch {
                Dimens.defaultToolbarHeight = dp(54)
            } else {
                Dimens.defaultToolbarHeight = dp(44)
            }
        }
        return Dimens.defaultToolbarHeight!
    }

    public static var bottomTabBarHeight: CGFloat = dp(60)
    public static var bottomButtonHeight: CGFloat {
        if UIScreen.hasTopNotch {
            return dp(45)
        } else {
            return dp(55)
        }
    }

    public static let standardCornerRadius: CGFloat = dp(8)
}
