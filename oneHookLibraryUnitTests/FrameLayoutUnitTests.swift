import XCTest
@testable import oneHookLibrary

class FrameLayoutUnitTests: XCTestCase {

    func testSizeThatFits() {
        let layout = FrameLayout()
        layout.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 30, height: 10)
        }))

        XCTAssertEqual(layout.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                 height: CGFloat.greatestFiniteMagnitude)),
                      CGSize(width: 30, height: 10))
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 30, height: 10)])

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 20, height: 10)
        }))

        XCTAssertEqual(layout.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                  height: CGFloat.greatestFiniteMagnitude)),
                       CGSize(width: 30, height: 10))
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 30, height: 10),
                        CGRect(x: 0, y: 0, width: 20, height: 10)])

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 50, height: 80)
        }))

        XCTAssertEqual(layout.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                  height: CGFloat.greatestFiniteMagnitude)),
                       CGSize(width: 50, height: 80))
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 30, height: 10),
                        CGRect(x: 0, y: 0, width: 20, height: 10),
                        CGRect(x: 0, y: 0, width: 50, height: 80)])
    }

    func testSizeWithPaddingAndMargin() {
        let layout = FrameLayout()
        layout.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        layout.paddingStart = 5
        layout.paddingEnd = 6
        layout.paddingTop = 7
        layout.paddingBottom = 8

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 30, height: 10)
            view.marginStart = 1
            view.marginEnd = 2
            view.marginTop = 3
            view.marginBottom = 4
        }))

        XCTAssertEqual(layout.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                  height: CGFloat.greatestFiniteMagnitude)),
                       CGSize(width: 44, height: 32))
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 6, y: 10, width: 30, height: 10)])
    }

    func testGravity() {
        let layout = FrameLayout()
        layout.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = .start
        }))

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = .end
        }))

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = .bottom
        }))

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = [.bottom, .end]
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 10, height: 10),
                        CGRect(x: 90, y: 0, width: 10, height: 10),
                        CGRect(x: 0, y: 90, width: 10, height: 10),
                        CGRect(x: 90, y: 90, width: 10, height: 10)])
    }

    func testGravityWithFill() {
        let layout = FrameLayout()
        layout.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = [.start, .fillHorizontal]
        }))

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = [.end, .fillVertical]
        }))

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = [.bottom, .centerHorizontal]
        }))

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = [.bottom, .fillHorizontal]
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 100, height: 10),
                        CGRect(x: 90, y: 0, width: 10, height: 100),
                        CGRect(x: 45, y: 90, width: 10, height: 10),
                        CGRect(x: 0, y: 90, width: 100, height: 10)])
    }

    func testGravityWithFillAndMargin() {
        let layout = FrameLayout()
        layout.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = [.start, .fillHorizontal]
            view.marginEnd = 15
        }))

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = [.end, .fillVertical]
            view.marginTop = 10
        }))

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = [.bottom, .centerHorizontal]
            view.margin = 10
        }))

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = .fill
            view.margin = 10
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 85, height: 10),
                        CGRect(x: 90, y: 10, width: 10, height: 90),
                        CGRect(x: 45, y: 80, width: 10, height: 10),
                        CGRect(x: 10, y: 10, width: 80, height: 80)])
    }

    func testGravityWithPadding() {
        let layout = FrameLayout()
        layout.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

        let view1 = BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = [.start, .centerVertical]
        })

        layout.addSubview(view1)

        let view2 = BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = [.end, .centerVertical]
        })

        layout.addSubview(view2)

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
        [CGRect(x: 0, y: 45, width: 10, height: 10),
         CGRect(x: 90, y: 45, width: 10, height: 10)])

        layout.padding = 10

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
        [CGRect(x: 10, y: 45, width: 10, height: 10),
         CGRect(x: 80, y: 45, width: 10, height: 10)])
    }
}
