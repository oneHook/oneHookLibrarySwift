import UIKit

public class EGTextField: EDTextField {

    public lazy var rightContainer = optionalBuilder {
        StackLayout().apply {
            $0.orientation = .horizontal
            $0.layoutGravity = .center
            self.rightView = $0
            self.rightViewMode = .always
        }
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    public func commonInit() {
        padding = Dimens.marginSmall
    }

    public override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        let rightViewSize = rightContainer.value?.sizeThatFits(bounds.size) ?? .zero
        return CGRect(
            x: bounds.width - rightViewSize.width - paddingEnd,
            y: (bounds.height - rightViewSize.height) / 2,
            width: rightViewSize.width,
            height: rightViewSize.height
        )
    }

    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rightViewSize = rightContainer.value?.sizeThatFits(bounds.size) ?? .zero
        let result = super.textRect(forBounds: bounds)
        if rightViewSize == .zero {
            return result
        } else {
            return CGRect(
                x: result.minX,
                y: result.minY,
                width: result.width - rightViewSize.width - paddingEnd,
                height: result.height
            )
        }
    }
}
