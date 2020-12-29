import UIKit

public protocol Tappable {
    var didTap: ((UIView) -> Void)? {get set}
}
