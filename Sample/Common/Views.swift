import UIKit
import oneHookLibrary

extension EDLabel {

    static func h1() -> EDLabel {
        EDLabel().apply {
            $0.font = UIFont.systemFont(ofSize: 20)
            $0.textColor = .primaryTextColor
        }
    }

    static func h2() -> EDLabel {
        EDLabel().apply {
            $0.font = UIFont.systemFont(ofSize: 16)
            $0.textColor = .primaryTextColor
        }
    }
}
