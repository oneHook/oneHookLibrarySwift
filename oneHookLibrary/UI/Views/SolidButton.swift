#if canImport(UIKit)
import UIKit

public class SolidButton: EDButton {

    private var _backgroundColors = [UInt: UIColor]()

    public func setBackgroundColor(_ color: UIColor?, for state: UIControl.State) {
        _backgroundColors[state.rawValue] = color
        let backgroundImage = color.map { UIImage(color: $0) } ?? nil
        switch state {
        case .normal:
            setBackgroundImage(backgroundImage, for: .normal)
            if _backgroundColors[UIControl.State.highlighted.rawValue] == nil {
                setBackgroundColor(color?.darker(by: 20, alpha: 0.8), for: .highlighted)
            }
        default:
            setBackgroundImage(backgroundImage, for: state)
        }
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *), UITraitCollection.current.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            for (stateInt, color) in _backgroundColors {
                let state = UIControl.State(rawValue: stateInt)
                setBackgroundColor(color, for: state)
            }
        }
    }
}
#endif
