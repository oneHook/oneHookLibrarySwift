import XCTest
@testable import oneHookLibrary

class FlowLayoutUnitTests: XCTestCase {

    func testOneView() {
        let layout = FlowLayout()
        layout.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let view = BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 20, height: 20)
        })
        layout.addSubview(view)

        /* no padding, no margin */
        XCTAssertEqual(layout.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                  height: CGFloat.greatestFiniteMagnitude)),
                       CGSize(width: 20, height: 20))
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 20, height: 20)])

        /* with margin */
        view.marginStart = 10
        view.marginEnd = 5
        view.marginTop = 3
        view.marginBottom = 8
        XCTAssertEqual(layout.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                  height: CGFloat.greatestFiniteMagnitude)),
                       CGSize(width: 35, height: 31))
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 10, y: 3, width: 20, height: 20)])

        /* add in padding */
        layout.paddingStart = 3
        layout.paddingEnd = 4
        layout.paddingTop = 8
        layout.paddingBottom = 10
        XCTAssertEqual(layout.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                  height: CGFloat.greatestFiniteMagnitude)),
                       CGSize(width: 42, height: 49))
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 13, y: 11, width: 20, height: 20)])
    }

    func testOneViewEdge() {
        let layout = FlowLayout()
        layout.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let view = BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 100, height: 100)
        })
        layout.addSubview(view)

        /* no padding, no margin */
        XCTAssertEqual(layout.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                  height: CGFloat.greatestFiniteMagnitude)),
                       CGSize(width: 100, height: 100))
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 100, height: 100)])

        /* with margin */
        view.marginStart = 5
        view.marginEnd = 5
        view.marginTop = 5
        view.marginBottom = 5
        XCTAssertEqual(layout.sizeThatFits(CGSize(width: 100,
                                                  height: 100)),
                       CGSize(width: 100, height: 110))
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 5, y: 5, width: 90, height: 100)])

        /* with padding */
        layout.padding = 8
        XCTAssertEqual(layout.sizeThatFits(CGSize(width: 100,
                                                  height: 100)),
                       CGSize(width: 100, height: 126))
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 13, y: 13, width: 74, height: 100)])
    }

    func testTwoViewsSameLine() {
        let layout = FlowLayout()
        layout.horizontalSpacing = 10
        layout.verticalSpacing = 10
        layout.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let view1 = BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 20, height: 20)
        })
        layout.addSubview(view1)

        let view2 = BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 20, height: 20)
        })
        layout.addSubview(view2)

        /* no padding, no margin */
        XCTAssertEqual(layout.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                  height: CGFloat.greatestFiniteMagnitude)),
                       CGSize(width: 50, height: 20))
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 20, height: 20),
                        CGRect(x: 30, y: 0, width: 20, height: 20)])

        /* with margins */

        view1.marginStart = 1
        view1.marginTop = 2
        view1.marginBottom = 3
        view1.marginEnd = 4
        XCTAssertEqual(layout.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                  height: CGFloat.greatestFiniteMagnitude)),
                       CGSize(width: 55, height: 25))
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 1, y: 2, width: 20, height: 20),
                        CGRect(x: 35, y: 0, width: 20, height: 20)])

        /* with paddings */

        layout.paddingStart = 1
        layout.paddingEnd = 2
        layout.paddingTop = 3
        layout.paddingBottom = 4
        XCTAssertEqual(layout.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude,
                                                  height: CGFloat.greatestFiniteMagnitude)),
                       CGSize(width: 58, height: 32))
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 2, y: 5, width: 20, height: 20),
                        CGRect(x: 36, y: 3, width: 20, height: 20)])
    }

    func testTwoViewsDiffLine() {
        let layout = FlowLayout()
        layout.horizontalSpacing = 30
        layout.verticalSpacing = 10
        layout.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let view1 = BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 40, height: 40)
        })
        layout.addSubview(view1)

        let view2 = BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 40, height: 40)
        })
        layout.addSubview(view2)

        /* no padding, no margin */
        XCTAssertEqual(layout.sizeThatFits(CGSize(width: 100,
                                                  height: 100)),
                       CGSize(width: 40, height: 90))
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 40, height: 40),
                        CGRect(x: 0, y: 50, width: 40, height: 40)])
    }

    func testGeneralCase() {
        let layout = FlowLayout()
        layout.horizontalSpacing = 10
        layout.verticalSpacing = 10
        layout.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

        for _ in 0..<5 {
            let view = BaseView().apply({ (view) in
                view.layoutSize = CGSize(width: 40, height: 40)
            })
            layout.addSubview(view)
        }

        /* no padding, no margin */
        XCTAssertEqual(layout.sizeThatFits(CGSize(width: 100,
                                                  height: 100)),
                       CGSize(width: 90, height: 140))
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 40, height: 40),
                        CGRect(x: 50, y: 0, width: 40, height: 40),
                        CGRect(x: 0, y: 50, width: 40, height: 40),
                        CGRect(x: 50, y: 50, width: 40, height: 40),
                        CGRect(x: 0, y: 100, width: 40, height: 40)])

        layout.bounds = CGRect(origin: .zero, size: CGSize(width: 90, height: 140))
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 40, height: 40),
                        CGRect(x: 50, y: 0, width: 40, height: 40),
                        CGRect(x: 0, y: 50, width: 40, height: 40),
                        CGRect(x: 50, y: 50, width: 40, height: 40),
                        CGRect(x: 0, y: 100, width: 40, height: 40)])
    }
}
