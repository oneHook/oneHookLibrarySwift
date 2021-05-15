import UIKit

public let navButtonSize = dp(40.0)

public class ButtonGenerator {

    public static func navigationButton() -> EDButton {
        EDButton().apply({ (button) in
            button.setBackgroundImage(UIImage.solid(.clear), for: .normal)
            button.setBackgroundImage(UIImage.solid(UIColor.ed_toolbarBackgroundColor
                                                        .darker(by: 20, alpha: 0.5)),
                                      for: .highlighted)
            button.adjustsImageWhenHighlighted = false
            button.setTitleColor(.ed_toolbarTextColor, for: .normal)
            button.layoutSize = CGSize(width: navButtonSize, height: navButtonSize)
            button.bounds = CGRect(x: 0, y: 0, width: navButtonSize, height: navButtonSize)
            button.layer.cornerRadius = navButtonSize / 2.0
            button.layer.masksToBounds = true
            button.iconPosition = .none
        })
    }
}
