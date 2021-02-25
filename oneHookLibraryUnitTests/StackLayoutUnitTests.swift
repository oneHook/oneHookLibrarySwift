import XCTest
@testable import oneHookLibrary

class StackLayoutUnitTests: XCTestCase {

    func testHorizontalTagLabel() {
        let layout = StackLayout()
        layout.orientation = .horizontal
        layout.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        layout.spacing = 10
        let view1 = BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 14, height: 14)
            view.layoutGravity = .centerVertical
        })
        let view2 = BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 30, height: 20)
            view.layoutGravity = .centerVertical
        })
        layout.addSubview(view1)
        layout.addSubview(view2)

        XCTAssertEqual(layout.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                  height: CGFloat.greatestFiniteMagnitude)),
                       CGSize(width: 54, height: 20))
        layout.frame = CGRect(origin: .zero, size: CGSize(width: 54, height: 20))
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 3, width: 14, height: 14),
                        CGRect(x: 24, y: 0, width: 30, height: 20)])

        view1.isHidden = true

        XCTAssertEqual(layout.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                  height: CGFloat.greatestFiniteMagnitude)),
                       CGSize(width: 30, height: 20))
        layout.frame = CGRect(origin: .zero, size: CGSize(width: 30, height: 20))
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 3, width: 14, height: 14),
                        CGRect(x: 0, y: 0, width: 30, height: 20)])
    }

    func testHorizontalSizeThatFits() {
        let layout = StackLayout()
        layout.orientation = .horizontal
        layout.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 20, height: 10)
        }))
        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 20, height: 10)
        }))
        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 20, height: 10)
        }))

        XCTAssertEqual(layout.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                  height: CGFloat.greatestFiniteMagnitude)),
                       CGSize(width: 60, height: 10))
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 20, height: 10),
                        CGRect(x: 20, y: 0, width: 20, height: 10),
                        CGRect(x: 40, y: 0, width: 20, height: 10)])

        layout.spacing = 10
        XCTAssertEqual(layout.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                  height: CGFloat.greatestFiniteMagnitude)),
                       CGSize(width: 80, height: 10))
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 20, height: 10),
                        CGRect(x: 30, y: 0, width: 20, height: 10),
                        CGRect(x: 60, y: 0, width: 20, height: 10)])

        layout.spacing = -10
        XCTAssertEqual(layout.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                  height: CGFloat.greatestFiniteMagnitude)),
                       CGSize(width: 40, height: 10))
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 20, height: 10),
                        CGRect(x: 10, y: 0, width: 20, height: 10),
                        CGRect(x: 20, y: 0, width: 20, height: 10)])
    }

    func testHorizontalGravity() {
        let layout = StackLayout()
        layout.orientation = .horizontal
        layout.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 20, height: 10)
            view.layoutGravity = .top
        }))
        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 20, height: 10)
            view.layoutGravity = .center
        }))
        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 20, height: 10)
            view.layoutGravity = .bottom
        }))

        layout.spacing = 10

        XCTAssertEqual(layout.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                  height: CGFloat.greatestFiniteMagnitude)),
                       CGSize(width: 80, height: 10))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 20, height: 10),
                        CGRect(x: 30, y: 45, width: 20, height: 10),
                        CGRect(x: 60, y: 90, width: 20, height: 10)])

        layout.spacing = -10
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 20, height: 10),
                        CGRect(x: 10, y: 45, width: 20, height: 10),
                        CGRect(x: 20, y: 90, width: 20, height: 10)])
    }

    func testHorizontalGravityAndPaddingMargin() {
        let layout = StackLayout()
        layout.orientation = .horizontal
        layout.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        layout.padding = 5

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = .top
            view.marginEnd = 5
        }))
        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = .center
            view.marginStart = 5
        }))
        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = .bottom
            view.marginBottom = 30
        }))

        layout.spacing = 10
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 5, y: 5, width: 10, height: 10),
                        CGRect(x: 35, y: 45, width: 10, height: 10),
                        CGRect(x: 55, y: 55, width: 10, height: 10)])

        layout.spacing = -10
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 5, y: 5, width: 10, height: 10),
                        CGRect(x: 15, y: 45, width: 10, height: 10),
                        CGRect(x: 15, y: 55, width: 10, height: 10)])
    }

    func testVerticalSizeThatFits() {
        let layout = StackLayout()
        layout.orientation = .vertical
        layout.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 20, height: 10)
        }))
        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 20, height: 10)
        }))
        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 20, height: 10)
        }))

        XCTAssertEqual(layout.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                  height: CGFloat.greatestFiniteMagnitude)),
                       CGSize(width: 20, height: 30))
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 20, height: 10),
                        CGRect(x: 0, y: 10, width: 20, height: 10),
                        CGRect(x: 0, y: 20, width: 20, height: 10)])

        layout.spacing = 10
        XCTAssertEqual(layout.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                  height: CGFloat.greatestFiniteMagnitude)),
                       CGSize(width: 20, height: 50))
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 20, height: 10),
                        CGRect(x: 0, y: 20, width: 20, height: 10),
                        CGRect(x: 0, y: 40, width: 20, height: 10)])

        layout.spacing = -10
        XCTAssertEqual(layout.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                  height: CGFloat.greatestFiniteMagnitude)),
                       CGSize(width: 20, height: 10))
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 20, height: 10),
                        CGRect(x: 0, y: 0, width: 20, height: 10),
                        CGRect(x: 0, y: 0, width: 20, height: 10)])
    }

    func testVerticalGravity() {
        let layout = StackLayout()
        layout.orientation = .vertical
        layout.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 20, height: 10)
            view.layoutGravity = .start
        }))
        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 20, height: 10)
            view.layoutGravity = .center
        }))
        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 20, height: 10)
            view.layoutGravity = .end
        }))

        layout.spacing = 10
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 20, height: 10),
                        CGRect(x: 40, y: 20, width: 20, height: 10),
                        CGRect(x: 80, y: 40, width: 20, height: 10)])

        layout.spacing = -10
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 20, height: 10),
                        CGRect(x: 40, y: 0, width: 20, height: 10),
                        CGRect(x: 80, y: 0, width: 20, height: 10)])
    }

    func testVerticalGravityAndPaddingMargin() {
        let layout = StackLayout()
        layout.orientation = .vertical
        layout.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        layout.padding = 5

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = .start
            view.marginEnd = 5
        }))
        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = .center
            view.marginStart = 5
        }))
        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = .end
            view.marginBottom = 30
        }))

        layout.spacing = 10
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 5, y: 5, width: 10, height: 10),
                        CGRect(x: 45, y: 25, width: 10, height: 10),
                        CGRect(x: 85, y: 45, width: 10, height: 10)])

        layout.spacing = -10
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 5, y: 5, width: 10, height: 10),
                        CGRect(x: 45, y: 5, width: 10, height: 10),
                        CGRect(x: 85, y: 5, width: 10, height: 10)])
    }

    func testVerticalWithPadding() {
        let layout = StackLayout()
        layout.orientation = .vertical
        layout.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        layout.paddingStart = 1
        layout.paddingTop = 2
        layout.paddingEnd = 3
        layout.paddingBottom = 4

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = .start
            view.marginEnd = 5
        }))
        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = .center
            view.marginStart = 5
        }))
        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = .end
            view.marginBottom = 5
        }))

        layout.spacing = 0
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 1, y: 2, width: 10, height: 10),
                        CGRect(x: 44, y: 12, width: 10, height: 10),
                        CGRect(x: 87, y: 22, width: 10, height: 10)])

        layout.spacing = 10
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 1, y: 2, width: 10, height: 10),
                        CGRect(x: 44, y: 22, width: 10, height: 10),
                        CGRect(x: 87, y: 42, width: 10, height: 10)])

        layout.spacing = -1
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 1, y: 2, width: 10, height: 10),
                        CGRect(x: 44, y: 11, width: 10, height: 10),
                        CGRect(x: 87, y: 20, width: 10, height: 10)])
    }

    func testHorizontalWithPadding() {
        let layout = StackLayout()
        layout.orientation = .horizontal
        layout.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        layout.paddingStart = 1
        layout.paddingTop = 2
        layout.paddingEnd = 3
        layout.paddingBottom = 4

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = .top
            view.marginEnd = 5
        }))
        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = .center
            view.marginStart = 5
        }))
        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = .bottom
            view.marginBottom = 5
        }))

        layout.spacing = 0
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 1, y: 2, width: 10, height: 10),
                        CGRect(x: 21, y: 44, width: 10, height: 10),
                        CGRect(x: 31, y: 81, width: 10, height: 10)])

        layout.spacing = 10
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 1, y: 2, width: 10, height: 10),
                        CGRect(x: 31, y: 44, width: 10, height: 10),
                        CGRect(x: 51, y: 81, width: 10, height: 10)])

        layout.spacing = -1
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 1, y: 2, width: 10, height: 10),
                        CGRect(x: 20, y: 44, width: 10, height: 10),
                        CGRect(x: 29, y: 81, width: 10, height: 10)])
    }
}
