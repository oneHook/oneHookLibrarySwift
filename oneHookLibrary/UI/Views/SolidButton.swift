import UIKit

public class SolidButton: EDButton {

    private var _backgroundColorNormal: UIColor?
    private var _backgroundColorHighlight: UIColor?
    private var _backgroundColorSelected: UIColor?
    private var _backgroundColorDisabled: UIColor?

    public func setBackgroundColor(_ color: UIColor?, for state: UIControl.State) {
        let backgroundImage = color.map { UIImage(color: $0) } ?? nil
        switch state {
        case .normal:
            _backgroundColorNormal = color
            setBackgroundImage(backgroundImage, for: .normal)
            if _backgroundColorHighlight == nil {
                setBackgroundColor(color?.darker(by: 20, alpha: 0.8), for: .highlighted)
            }
        case .highlighted:
            _backgroundColorHighlight = color
            setBackgroundImage(backgroundImage, for: .highlighted)
        case .selected:
            _backgroundColorSelected = color
            setBackgroundImage(backgroundImage, for: .selected)
        case .disabled:
            _backgroundColorDisabled = color
            setBackgroundImage(backgroundImage, for: .disabled)
        default:
            break
        }
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *), UITraitCollection.current.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            setBackgroundColor(_backgroundColorHighlight, for: .highlighted)
            setBackgroundColor(_backgroundColorNormal, for: .normal)
            setBackgroundColor(_backgroundColorSelected, for: .selected)
            setBackgroundColor(_backgroundColorDisabled, for: .disabled)
        }
    }
}
