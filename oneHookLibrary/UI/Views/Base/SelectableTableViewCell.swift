import UIKit

open class SelectableTableViewCell: UITableViewCell {

    open var highlightBackgroundColor: UIColor {
        SharedCustomization.defaultCellBackgroundSelected
    }

    open var normalBackgroundColor: UIColor {
        SharedCustomization.defaultBackgroundWhite
    }

    override open func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        UIView.animate(withDuration: animated ? .defaultAnimation : 0) { [weak self] in
            guard let self = self else {
                return
            }
            self.backgroundColor = self.isSelected ? self.highlightBackgroundColor : self.normalBackgroundColor
        }
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        addHighlightIfNeeded()
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        removeHighlightIfNeeded()
    }

    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        removeHighlightIfNeeded()
    }

    open func addHighlightIfNeeded() {
        if !isSelected {
            UIView.animate(withDuration: .defaultAnimationSmall) { [weak self] in
                guard let self = self else {
                    return
                }
                self.backgroundColor = self.highlightBackgroundColor
            }
        }
    }

    open func removeHighlightIfNeeded() {
        if !isSelected {
            UIView.animate(withDuration: .defaultAnimationSmall) { [weak self] in
                guard let self = self else {
                    return
                }
                self.backgroundColor = self.normalBackgroundColor
            }
        }
    }
}
