import UIKit
import oneHookLibrary

class SimpleTableViewCell: SelectableTableViewCell {

    private let stackLayout = StackLayout().apply {
        $0.padding = Dimens.marginMedium
        $0.contentGravity = .centerVertical
        $0.orientation = .vertical
        $0.spacing = Dimens.marginMedium
    }

    let titleLabel = EDLabel().apply {
        $0.font = UIFont.systemFont(ofSize: 15)
    }

    let subtitleLabel = EDLabel().apply {
        $0.font = UIFont.systemFont(ofSize: 12)
    }

    override func commonInit() {
        super.commonInit()
        contentView.addSubview(stackLayout.apply {
            $0.addSubview(titleLabel)
            $0.addSubview(subtitleLabel)
        })
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        stackLayout.matchParent()
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        stackLayout.sizeThatFits(size)
    }
}
