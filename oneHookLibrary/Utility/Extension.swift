import UIKit

public struct AnyCodable: Codable {
    public init() {}
}

public struct AnyIdentifiable: Codable {
    public var id: String
    public init() {
        id = ""
    }
}

public protocol KotlinStyle {}

public extension KotlinStyle where Self: Any {

    func applyCopy(_ closure: (inout Self) -> Void) -> Self {
        var copy = self
        closure(&copy)
        return copy
    }

    func `do`(_ closure: (Self) -> Void) {
        closure(self)
    }
}

public extension KotlinStyle where Self: AnyObject {

    func apply(_ closure: (Self) -> Void) -> Self {
        closure(self)
        return self
    }

    func also(_ closure: (Self) -> Void) {
        closure(self)
    }
}

extension NSObject: KotlinStyle { }
extension CGPoint: KotlinStyle { }
extension CGRect: KotlinStyle { }
extension CGSize: KotlinStyle { }
extension Int: KotlinStyle { }
extension String: KotlinStyle { }
extension Array: KotlinStyle { }

#if os(iOS) || os(tvOS)
extension UIEdgeInsets: KotlinStyle {}
#endif

public func fatalErrorNotImplementedBySubclass(_ function: String = #function) -> Never {
    fatalError("\(function) has not been implemented by subclass")
}
