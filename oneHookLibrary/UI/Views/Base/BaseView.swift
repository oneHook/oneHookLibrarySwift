import UIKit

public struct Gravity: OptionSet {
    public let rawValue: Int

    public static let none = Gravity(rawValue: 1 << 0)
    public static let start = Gravity(rawValue: 1 << 1)
    public static let end = Gravity(rawValue: 1 << 2)
    public static let top = Gravity(rawValue: 1 << 3)
    public static let bottom = Gravity(rawValue: 1 << 4)
    public static let fillHorizontal = Gravity(rawValue: 1 << 5)
    public static let fillVertical = Gravity(rawValue: 1 << 6)
    public static let fill: Gravity = [.fillHorizontal, .fillVertical]
    public static let centerVertical = Gravity(rawValue: 1 << 7)
    public static let centerHorizontal = Gravity(rawValue: 1 << 8)
    public static let center: Gravity = [.centerVertical, .centerHorizontal]

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public class LayoutParams: NSObject {

    var marginStart: CGFloat = 0
    var marginEnd: CGFloat = 0
    var marginTop: CGFloat = 0
    var marginBottom: CGFloat = 0
    var paddingStart: CGFloat = 0
    var paddingEnd: CGFloat = 0
    var paddingTop: CGFloat = 0
    var paddingBottom: CGFloat = 0
    var layoutWeight: CGFloat = 0
    var layoutSize: CGSize = CGSize.zero
    var layoutGravity: Gravity = .none
    var shouldSkip: Bool = false
}

public protocol LayoutParamsProtocol {
    var layoutParams: LayoutParams {get}
}

extension UIView: LayoutParamsProtocol {

    private static let defaultLayoutParams = LayoutParams()

    @objc open var layoutParams: LayoutParams {
        UIView.defaultLayoutParams
    }

    public var marginStart: CGFloat {
        get {
            layoutParams.marginStart
        }
        set {
            layoutParams.marginStart = newValue
        }
    }

    public var marginEnd: CGFloat {
        get {
            layoutParams.marginEnd
        }
        set {
            layoutParams.marginEnd = newValue
        }
    }

    public var marginTop: CGFloat {
        get {
            layoutParams.marginTop
        }
        set {
            layoutParams.marginTop = newValue
        }
    }

    public var marginBottom: CGFloat {
        get {
            layoutParams.marginBottom
        }
        set {
            layoutParams.marginBottom = newValue
        }
    }

    public var margin: CGFloat {
        get {
            layoutParams.marginStart
        }
        set {
            layoutParams.marginStart = newValue
            layoutParams.marginEnd = newValue
            layoutParams.marginTop = newValue
            layoutParams.marginBottom = newValue
        }
    }

    public var paddingStart: CGFloat {
        get {
            layoutParams.paddingStart
        }
        set {
            layoutParams.paddingStart = newValue
        }
    }

    public var paddingEnd: CGFloat {
        get {
            layoutParams.paddingEnd
        }
        set {
            layoutParams.paddingEnd = newValue
        }
    }

    public var paddingTop: CGFloat {
        get {
            layoutParams.paddingTop
        }
        set {
            layoutParams.paddingTop = newValue
        }
    }

    public var paddingBottom: CGFloat {
        get {
            layoutParams.paddingBottom
        }
        set {
            layoutParams.paddingBottom = newValue
        }
    }

    @objc public var padding: CGFloat {
        get {
            layoutParams.paddingStart
        }
        set {
            layoutParams.paddingStart = newValue
            layoutParams.paddingEnd = newValue
            layoutParams.paddingTop = newValue
            layoutParams.paddingBottom = newValue
        }
    }

    public var layoutWeight: CGFloat {
        get {
            layoutParams.layoutWeight
        }
        set {
            layoutParams.layoutWeight = newValue
        }
    }

    public var layoutSize: CGSize {
        get {
            layoutParams.layoutSize
        }
        set {
            layoutParams.layoutSize = newValue
        }
    }

    public var layoutGravity: Gravity {
        get {
            layoutParams.layoutGravity
        }
        set {
            layoutParams.layoutGravity = newValue
        }
    }

    public var shouldSkip: Bool {
        get {
            layoutParams.shouldSkip
        }
        set {
            layoutParams.shouldSkip = newValue
        }
    }

    public var safeAreaInsetsCompat: UIEdgeInsets {
        if #available(iOS 11.0, *) {
            return self.safeAreaInsets
        }
        return UIEdgeInsets.zero
    }

    public func matchParent(top topMargin: CGFloat = 0,
                            left leftMargin: CGFloat = 0,
                            bottom bottomMargin: CGFloat = 0,
                            right rightMargin: CGFloat = 0) {
        guard let parent = self.superview else {
            return
        }
        self.frame = CGRect(x: leftMargin,
                            y: topMargin,
                            width: parent.bounds.width - leftMargin - rightMargin,
                            height: parent.bounds.height - topMargin - bottomMargin)
    }

    public func putTop(top topMargin: CGFloat = 0,
                       left leftMargin: CGFloat = 0,
                       right rightMargin: CGFloat = 0,
                       height viewHeight: CGFloat) {
        guard let parent = self.superview else {
            return
        }
        let hiddenFlag: CGFloat = self.isHidden ? 0 : 1
        let parentWidth = parent.bounds.width
        self.frame = CGRect(x: leftMargin,
                            y: topMargin,
                            width: parentWidth - leftMargin - rightMargin,
                            height: viewHeight * hiddenFlag)
    }

    public func putTopLeft(top topMargin: CGFloat = 0,
                           left leftMargin: CGFloat = 0) {
        let hiddenFlag: CGFloat = self.isHidden ? 0 : 1
        self.frame = CGRect(x: leftMargin * hiddenFlag,
                            y: topMargin * hiddenFlag,
                            width: self.bounds.width * hiddenFlag,
                            height: self.bounds.height * hiddenFlag)
    }

    public func putTopRight(top topMargin: CGFloat = 0,
                            right rightMargin: CGFloat = 0) {
        guard let parent = self.superview else {
            return
        }
        let hiddenFlag: CGFloat = self.isHidden ? 0 : 1
        let parentWidth = parent.bounds.width
        self.frame = CGRect(x: parentWidth - (rightMargin + self.bounds.width) * hiddenFlag,
                            y: topMargin * hiddenFlag,
                            width: self.bounds.width * hiddenFlag,
                            height: self.bounds.height * hiddenFlag)
    }

    public func putBottom(left leftMargin: CGFloat = 0,
                          bottom bottomMargin: CGFloat = 0,
                          right rightMargin: CGFloat = 0,
                          height viewHeight: CGFloat) {
        guard let parent = self.superview else {
            return
        }
        let hiddenFlag: CGFloat = self.isHidden ? 0 : 1
        let parentWidth = parent.bounds.width
        let parentHeight = parent.bounds.height
        self.frame = CGRect(x: leftMargin,
                            y: parentHeight - bottomMargin - viewHeight * hiddenFlag,
                            width: parentWidth - leftMargin - rightMargin,
                            height: viewHeight * hiddenFlag)
    }

    public func putBottomLeft(bottom bottomMargin: CGFloat = 0,
                              left leftMargin: CGFloat = 0) {
        guard let parent = self.superview else {
            return
        }
        let hiddenFlag: CGFloat = self.isHidden ? 0 : 1
        let parentHeight = parent.bounds.height
        self.frame = CGRect(x: leftMargin * hiddenFlag,
                            y: parentHeight - (bottomMargin + self.bounds.height) * hiddenFlag,
                            width: self.bounds.width * hiddenFlag,
                            height: self.bounds.height * hiddenFlag)
    }

    public func putBottomRight(bottom bottomMargin: CGFloat = 0,
                               right rightMargin: CGFloat = 0) {
        guard let parent = self.superview else {
            return
        }
        let hiddenFlag: CGFloat = self.isHidden ? 0 : 1
        let parentWidth = parent.bounds.width
        let parentHeight = parent.bounds.height
        self.frame = CGRect(x: parentWidth - (rightMargin + self.bounds.width) * hiddenFlag,
                            y: parentHeight - (bottomMargin + self.bounds.height) * hiddenFlag,
                            width: self.bounds.width * hiddenFlag,
                            height: self.bounds.height * hiddenFlag)
    }

    public func putTopCenter(top topMargin: CGFloat = 0,
                             width viewWidth: CGFloat,
                             height viewHeight: CGFloat) {
        guard let parent = self.superview else {
            return
        }
        let hiddenFlag: CGFloat = self.isHidden ? 0 : 1
        let parentWidth = parent.bounds.width
        self.frame = CGRect(x: (parentWidth - viewWidth) / 2,
                            y: topMargin * hiddenFlag,
                            width: viewWidth,
                            height: viewHeight * hiddenFlag)
    }

    public func putBottomCenter(bottom bottomMargin: CGFloat = 0,
                                width viewWidth: CGFloat,
                                height viewHeight: CGFloat) {
        guard let parent = self.superview else {
            return
        }
        let hiddenFlag: CGFloat = self.isHidden ? 0 : 1
        let parentWidth = parent.bounds.width
        let parentHeight = parent.bounds.height
        self.frame = CGRect(x: (parentWidth - viewWidth) / 2,
                            y: parentHeight - (viewHeight + bottomMargin) * hiddenFlag,
                            width: viewWidth,
                            height: viewHeight * hiddenFlag)
    }

    public func alignBelow(_ view: UIView,
                           top topMargin: CGFloat = 0,
                           height aHeight: CGFloat) {
        let hiddenFlag: CGFloat = self.isHidden ? 0 : 1
        self.frame = CGRect(x: view.frame.minX,
                            y: view.frame.maxY + topMargin * hiddenFlag,
                            width: view.frame.width,
                            height: aHeight * hiddenFlag)
    }

    public func below(_ view: UIView,
                      top topMargin: CGFloat = 0,
                      left leftMargin: CGFloat = 0,
                      right rightMargin: CGFloat = 0,
                      height aHeight: CGFloat) {
        let hiddenFlag: CGFloat = self.isHidden ? 0 : 1
        self.frame = CGRect(x: leftMargin,
                            y: view.frame.maxY + topMargin * hiddenFlag,
                            width: self.superview!.bounds.width - leftMargin - rightMargin,
                            height: aHeight * hiddenFlag)
    }

    public func alignAbove(_ view: UIView,
                           bottom bottomMargin: CGFloat = 0,
                           height aHeight: CGFloat) {
        let hiddenFlag: CGFloat = self.isHidden ? 0 : 1
        self.frame = CGRect(x: view.frame.minX,
                            y: view.frame.minY - bottomMargin - aHeight * hiddenFlag,
                            width: view.frame.width,
                            height: aHeight * hiddenFlag)
    }

    public func above(_ view: UIView,
                      left leftMargin: CGFloat = 0,
                      bottom bottomMargin: CGFloat = 0,
                      right rightMargin: CGFloat = 0,
                      height aHeight: CGFloat) {
        let hiddenFlag: CGFloat = self.isHidden ? 0 : 1
        self.frame = CGRect(x: leftMargin,
                            y: view.frame.minY - bottomMargin - aHeight * hiddenFlag,
                            width: self.superview!.bounds.width - leftMargin - rightMargin,
                            height: aHeight * hiddenFlag)
    }

    public func putCenterInParent(width aWidth: CGFloat,
                                  height aHeight: CGFloat) {
        guard let parent = self.superview else {
            return
        }
        self.bounds = CGRect(x: 0, y: 0, width: aWidth, height: aHeight)
        self.center = CGPoint(x: parent.bounds.width / 2, y: parent.bounds.height / 2)
    }

    public func getViewElement<T>(type: T.Type) -> T? {
        let svs = subviews.flatMap { $0.subviews }
        guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
        return element
    }
}

open class BaseControl: UIControl {

    private var _layoutParams: LayoutParams = LayoutParams()
    override open var layoutParams: LayoutParams {
        _layoutParams
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    open func commonInit() {

    }

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        if layoutSize == CGSize.zero {
            return super.sizeThatFits(size)
        }
        return CGSize(width: min(size.width, layoutSize.width),
                      height: min(size.height, layoutSize.height))
    }

    open func invalidateAppearance() {

    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *), UITraitCollection.current.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            invalidateAppearance()
        }
    }
}

open class BaseView: UIView {

    private var _layoutParams: LayoutParams = LayoutParams()
    override open var layoutParams: LayoutParams {
        _layoutParams
    }

    /// Expand the tap area of a view. Negative edge insets enlarge the tap area.
    public var hitTestEdgeInsets: UIEdgeInsets = .zero

    private lazy var viewDidFirstLayoutSingleton: Void = {
        viewDidFirstLayout()
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        _ = viewDidFirstLayoutSingleton
    }

    open func viewDidFirstLayout() {

    }

    open func commonInit() {

    }

    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        if layoutSize == CGSize.zero {
            return super.sizeThatFits(size)
        }
        return CGSize(width: min(size.width, layoutSize.width),
                      height: min(size.height, layoutSize.height))
    }

    open override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        guard
            hitTestEdgeInsets != .zero,
            !isHidden else {
            return super.point(inside: point, with: event)
        }

        return bounds.inset(by: hitTestEdgeInsets).contains(point)
    }

    open func invalidateAppearance() {

    }

    open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if #available(iOS 13.0, *), UITraitCollection.current.userInterfaceStyle != previousTraitCollection?.userInterfaceStyle {
            invalidateAppearance()
        }
    }
}
