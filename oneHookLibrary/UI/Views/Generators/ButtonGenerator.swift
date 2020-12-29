import UIKit

public let navButtonSize = dp(34.0)

public class ButtonGenerator {

    public static func navigationButton() -> EDButton {
        EDButton().apply({ (button) in
            button.setBackgroundImage(UIImage(color: .clear), for: .normal)
            button.setBackgroundImage(UIImage(color: SharedCustomization.defaultBackgroundWhite
                .autoDarker(by: 20)
                .withAlphaComponent(0.5)), for: .highlighted)
            button.adjustsImageWhenHighlighted = false
            button.setTitleColor(SharedCustomization.defaultTextWhite, for: .normal)
            button.layoutSize = CGSize(width: navButtonSize, height: navButtonSize)
            button.bounds = CGRect(x: 0, y: 0, width: navButtonSize, height: navButtonSize)
            button.layer.cornerRadius = navButtonSize / 2.0
            button.layer.masksToBounds = true
            button.iconPosition = .none
        })
    }
}
