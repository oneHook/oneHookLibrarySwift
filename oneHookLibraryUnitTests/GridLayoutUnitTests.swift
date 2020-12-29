import XCTest
@testable import oneHookLibrary

class GridLayoutUnitTests: XCTestCase {

    func testOneColumn() {
        let layout = GridLayout()
        layout.verticalSpacing = 20
        layout.horizontalSpacing = 10
        layout.cellHeight = 50
        layout.columnCount = 1
        layout.dividerWidth = 1
        layout.showDivider = false

        let view1 = BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 5, height: 5)
        })
        layout.addSubview(view1)

        XCTAssertEqual(layout.sizeThatFits(CGSize(width: 200,
                                                  height: CGFloat.greatestFiniteMagnitude)),
                       CGSize(width: 200, height: 50))

        let view2 = BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 5, height: 5)
        })
        layout.addSubview(view2)

        XCTAssertEqual(layout.sizeThatFits(CGSize(width: 200,
                                                  height: CGFloat.greatestFiniteMagnitude)),
                       CGSize(width: 200, height: 120))

        layout.showDivider = true
        XCTAssertEqual(layout.sizeThatFits(CGSize(width: 200,
                                                  height: CGFloat.greatestFiniteMagnitude)),
                       CGSize(width: 200, height: 120))
        var size = layout.sizeThatFits(CGSize(width: 200,
                                              height: CGFloat.greatestFiniteMagnitude))
        layout.frame = CGRect(origin: .zero, size: size)
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 200, height: 50),
                        CGRect(x: 0, y: 70, width: 200, height: 50)])

        layout.paddingStart = 20
        layout.paddingEnd = 30
        layout.paddingTop = 40
        layout.paddingBottom = 50

        size = layout.sizeThatFits(CGSize(
                                    width: 200,
                                    height: CGFloat.greatestFiniteMagnitude)
        )
        XCTAssertEqual(size,
                       CGSize(width: 200, height: 210))
        layout.frame = CGRect(origin: .zero, size: size)
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 20, y: 40, width: 150, height: 50),
                        CGRect(x: 20, y: 110, width: 150, height: 50)])
    }

    func testTwoColumns() {
        let layout = GridLayout()
        layout.verticalSpacing = 20
        layout.horizontalSpacing = 10
        layout.cellHeight = 50
        layout.columnCount = 2
        layout.dividerWidth = 1
        layout.showDivider = false

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 5, height: 5)
            view.layoutGravity = .centerVertical
        }))

        var size = layout.sizeThatFits(CGSize(width: 200,
                                              height: CGFloat.greatestFiniteMagnitude))
        XCTAssertEqual(size,
                       CGSize(width: 200, height: 50))

        layout.frame = CGRect(origin: .zero, size: size)
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 95, height: 50)])

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 5, height: 5)
            view.layoutGravity = .centerVertical
        }))

        size = layout.sizeThatFits(CGSize(width: 200,
                                          height: CGFloat.greatestFiniteMagnitude))
        XCTAssertEqual(size,
                       CGSize(width: 200, height: 50))

        layout.frame = CGRect(origin: .zero, size: size)
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 95, height: 50),
                        CGRect(x: 105, y: 0, width: 95, height: 50)])

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 5, height: 5)
            view.layoutGravity = .centerVertical
        }))

        size = layout.sizeThatFits(CGSize(width: 200,
                                          height: CGFloat.greatestFiniteMagnitude))
        XCTAssertEqual(size,
                       CGSize(width: 200, height: 120))

        layout.frame = CGRect(origin: .zero, size: size)
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 95, height: 50),
                        CGRect(x: 105, y: 0, width: 95, height: 50),
                        CGRect(x: 0, y: 70, width: 95, height: 50)])

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 5, height: 5)
            view.layoutGravity = .centerVertical
        }))

        size = layout.sizeThatFits(CGSize(width: 200,
                                          height: CGFloat.greatestFiniteMagnitude))
        XCTAssertEqual(size,
                       CGSize(width: 200, height: 120))

        layout.frame = CGRect(origin: .zero, size: size)
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 95, height: 50),
                        CGRect(x: 105, y: 0, width: 95, height: 50),
                        CGRect(x: 0, y: 70, width: 95, height: 50),
                        CGRect(x: 105, y: 70, width: 95, height: 50)])

        layout.paddingStart = 20
        layout.paddingEnd = 30
        layout.paddingTop = 40
        layout.paddingBottom = 50

        size = layout.sizeThatFits(CGSize(
                                    width: 200,
                                    height: CGFloat.greatestFiniteMagnitude)
        )
        XCTAssertEqual(size,
                       CGSize(width: 200, height: 210))
        layout.frame = CGRect(origin: .zero, size: size)
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 20, y: 40, width: 70, height: 50),
                        CGRect(x: 100, y: 40, width: 70, height: 50),
                        CGRect(x: 20, y: 110, width: 70, height: 50),
                        CGRect(x: 100, y: 110, width: 70, height: 50)])
    }

    func testThreeColumns() {
        let layout = GridLayout()
        layout.verticalSpacing = 20
        layout.horizontalSpacing = 10
        layout.cellHeight = 50
        layout.columnCount = 3
        layout.dividerWidth = 1
        layout.showDivider = false

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 5, height: 5)
            view.layoutGravity = .centerVertical
        }))

        var size = layout.sizeThatFits(CGSize(width: 200,
                                              height: CGFloat.greatestFiniteMagnitude))
        XCTAssertEqual(size,
                       CGSize(width: 200, height: 50))

        layout.frame = CGRect(origin: .zero, size: size)
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 60, height: 50)])

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 5, height: 5)
            view.layoutGravity = .centerVertical
        }))

        size = layout.sizeThatFits(CGSize(width: 200,
                                          height: CGFloat.greatestFiniteMagnitude))
        XCTAssertEqual(size,
                       CGSize(width: 200, height: 50))

        layout.frame = CGRect(origin: .zero, size: size)
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 60, height: 50),
                        CGRect(x: 70, y: 0, width: 60, height: 50)])

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 5, height: 5)
            view.layoutGravity = .centerVertical
        }))

        size = layout.sizeThatFits(CGSize(width: 200,
                                          height: CGFloat.greatestFiniteMagnitude))
        XCTAssertEqual(size,
                       CGSize(width: 200, height: 50))

        layout.frame = CGRect(origin: .zero, size: size)
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 60, height: 50),
                        CGRect(x: 70, y: 0, width: 60, height: 50),
                        CGRect(x: 140, y: 0, width: 60, height: 50)])

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 5, height: 5)
            view.layoutGravity = .centerVertical
        }))

        size = layout.sizeThatFits(CGSize(width: 200,
                                          height: CGFloat.greatestFiniteMagnitude))
        XCTAssertEqual(size,
                       CGSize(width: 200, height: 120))

        layout.frame = CGRect(origin: .zero, size: size)
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 60, height: 50),
                        CGRect(x: 70, y: 0, width: 60, height: 50),
                        CGRect(x: 140, y: 0, width: 60, height: 50),
                        CGRect(x: 0, y: 70, width: 60, height: 50)])
    }
}
