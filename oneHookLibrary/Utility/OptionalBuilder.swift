public func optionalBuilder<T>(_ builder: @escaping () -> T) -> OptionalBuilder<T> {
    let optionalBuilder = OptionalBuilder<T>()
    optionalBuilder.buildValue = builder
    return optionalBuilder
}

public func optionalBuilder<T>(_ builder: @escaping () -> T, clearer: ((T) -> Void)? = nil) -> OptionalBuilder<T> {
    let optionalBuilder = OptionalBuilder<T>()
    optionalBuilder.buildValue = builder
    optionalBuilder.clearValue = clearer
    return optionalBuilder
}

public class OptionalBuilder<T> {
    public private(set) var value: T?

    public var exists: Bool {
        value != nil
    }

    fileprivate var buildValue: (() -> T)!
    fileprivate var clearValue: ((T) -> Void)?

    private func build() -> T {
        let val = buildValue()
        value = val
        return val
    }

    @discardableResult
    public func getOrMake() -> T {
        value ?? build()
    }

    public func clear() {
        if let value = value {
            clearValue?(value)
        }
        value = nil
    }

    public func ifExists(_ function: (T) -> Void) {
        if let value = value {
            function(value)
        }
    }
}
