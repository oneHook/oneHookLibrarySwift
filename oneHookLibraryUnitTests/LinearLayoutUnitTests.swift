import XCTest
@testable import oneHookLibrary

// swiftlint:disable type_body_length file_length
class LinearLayoutUnitTests: XCTestCase {

    func testVerticalWeight() {
        let layout = LinearLayout()
        layout.orientation = .vertical
        layout.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 30, height: 10)
            view.layoutWeight = 1
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 30, height: 100)])

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 50, height: 10)
            view.layoutWeight = 1
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 30, height: 50),
                        CGRect(x: 0, y: 50, width: 50, height: 50)
            ])

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 50, height: 10)
            view.layoutWeight = 2
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 30, height: 25),
                        CGRect(x: 0, y: 25, width: 50, height: 25),
                        CGRect(x: 0, y: 50, width: 50, height: 50)
            ])
    }

    func testVerticalWeightAndGravity() {
        let layout = LinearLayout()
        layout.orientation = .vertical
        layout.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 30, height: 10)
            view.layoutWeight = 1
            view.layoutGravity = .end
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 70, y: 0, width: 30, height: 100)])

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 50, height: 10)
            view.layoutGravity = .center
            view.layoutWeight = 1
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 70, y: 0, width: 30, height: 50),
                        CGRect(x: 25, y: 50, width: 50, height: 50)
            ])

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 50, height: 10)
            view.layoutWeight = 2
            view.layoutGravity = .fillHorizontal
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 70, y: 0, width: 30, height: 25),
                        CGRect(x: 25, y: 25, width: 50, height: 25),
                        CGRect(x: 0, y: 50, width: 100, height: 50)
            ])
    }

    func testVerticalComplex() {
        let layout = LinearLayout()
        layout.orientation = .vertical
        layout.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 30, height: 10)
            view.layoutGravity = .end
            view.margin = 20
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 50, y: 20, width: 30, height: 10)])

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 50, height: 10)
            view.layoutGravity = .center
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 50, y: 20, width: 30, height: 10),
                        CGRect(x: 25, y: 50, width: 50, height: 10)
            ])

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 50, height: 10)
            view.layoutWeight = 1
            view.margin = 5
            view.layoutGravity = .fillHorizontal
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 50, y: 20, width: 30, height: 10),
                        CGRect(x: 25, y: 50, width: 50, height: 10),
                        CGRect(x: 5, y: 65, width: 90, height: 30)
            ])
    }

    func testVerticalComplex2() {
        let layout = LinearLayout()
        layout.orientation = .vertical
        layout.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 30, height: 10)
            view.layoutGravity = .end
            view.margin = 20
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 50, y: 20, width: 30, height: 10)])

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 50, height: 10)
            view.layoutGravity = .center
            view.layoutWeight = 1
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 50, y: 20, width: 30, height: 10),
                        CGRect(x: 25, y: 50, width: 50, height: 50)
            ])

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 50, height: 10)
            view.margin = 5
            view.layoutGravity = .fillHorizontal
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 50, y: 20, width: 30, height: 10),
                        CGRect(x: 25, y: 50, width: 50, height: 30),
                        CGRect(x: 5, y: 85, width: 90, height: 10)
            ])
    }

    func testHorizontalWeight() {
        let layout = LinearLayout()
        layout.orientation = .horizontal
        layout.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 30, height: 10)
            view.layoutWeight = 1
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 100, height: 10)])

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 50, height: 10)
            view.layoutWeight = 1
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 50, height: 10),
                        CGRect(x: 50, y: 0, width: 50, height: 10)
            ])

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 50, height: 10)
            view.layoutWeight = 2
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 25, height: 10),
                        CGRect(x: 25, y: 0, width: 25, height: 10),
                        CGRect(x: 50, y: 0, width: 50, height: 10)
            ])
    }

    func testHorizontalWeight2() {
        let layout = LinearLayout()
        layout.orientation = .horizontal
        layout.frame = CGRect(x: 0, y: 0, width: 120, height: 120)

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutWeight = 1
            view.layoutGravity = .fillVertical
        }))

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutWeight = 1
            view.layoutGravity = .fillVertical
        }))

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutWeight = 1
            view.layoutGravity = .fillVertical
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 40, height: 120),
                        CGRect(x: 40, y: 0, width: 40, height: 120),
                        CGRect(x: 80, y: 0, width: 40, height: 120)
            ])
    }

    func testHorizontalWeight3() {
        let layout = LinearLayout()
        layout.orientation = .horizontal
        layout.frame = CGRect(x: 0, y: 0, width: 140, height: 140)

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutWeight = 1
            view.layoutGravity = .fillVertical
        }))

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutWeight = 1
            view.layoutGravity = .fillVertical
            view.marginStart = 10
        }))

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutWeight = 1
            view.layoutGravity = .fillVertical
            view.marginStart = 10
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 0, width: 40, height: 140),
                        CGRect(x: 50, y: 0, width: 40, height: 140),
                        CGRect(x: 100, y: 0, width: 40, height: 140)
            ])
    }

    func testHorizontalWeightAndGravity() {
        let layout = LinearLayout()
        layout.orientation = .horizontal
        layout.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 30, height: 10)
            view.layoutWeight = 1
            view.layoutGravity = .bottom
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 90, width: 100, height: 10)])

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 50, height: 10)
            view.layoutGravity = .centerVertical
            view.layoutWeight = 1
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 90, width: 50, height: 10),
                        CGRect(x: 50, y: 45, width: 50, height: 10)
            ])

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 50, height: 10)
            view.layoutWeight = 2
            view.layoutGravity = .fillVertical
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 0, y: 90, width: 25, height: 10),
                        CGRect(x: 25, y: 45, width: 25, height: 10),
                        CGRect(x: 50, y: 0, width: 50, height: 100)
            ])
    }

    func testHorizontalComplex() {
        let layout = LinearLayout()
        layout.orientation = .horizontal
        layout.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 30, height: 10)
            view.layoutGravity = .bottom
            view.margin = 20
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 20, y: 70, width: 30, height: 10)])

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 50, height: 10)
            view.layoutGravity = .center
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 20, y: 70, width: 30, height: 10),
                        CGRect(x: 70, y: 45, width: 30, height: 10)
            ])

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 50, height: 10)
            view.layoutWeight = 1
            view.margin = 5
            view.layoutGravity = .fill
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 20, y: 70, width: 30, height: 10),
                        CGRect(x: 70, y: 45, width: 30, height: 10),
                        CGRect(x: 105, y: 5, width: 0, height: 90)
            ])
    }

    func testHorizontalComplex2() {
        let layout = LinearLayout()
        layout.orientation = .horizontal
        layout.frame = CGRect(x: 0, y: 0, width: 100, height: 100)

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 5, height: 10)
            view.layoutGravity = .bottom
            view.margin = 20
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 20, y: 70, width: 5, height: 10)])

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 999, height: 10)
            view.layoutGravity = .center
            view.layoutWeight = 1
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 20, y: 70, width: 5, height: 10),
                        CGRect(x: 45, y: 45, width: 55, height: 10)
            ])

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 35, height: 10)
            view.margin = 5
            view.layoutGravity = .fill
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }),
                       [CGRect(x: 20, y: 70, width: 5, height: 10),
                        CGRect(x: 45, y: 45, width: 10, height: 10),
                        CGRect(x: 60, y: 5, width: 35, height: 90)
            ])
    }

    func testWithPaddingVertical() {
        let layout = LinearLayout()
        layout.orientation = .vertical
        layout.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        layout.padding = 10

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = .start
            view.margin = 10
        }))
        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = .center
            view.margin = 10
        }))
        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = .end
            view.margin = 5
        }))
        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = .fill
            view.margin = 5
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }), [
            CGRect(x: 20, y: 20, width: 10, height: 10),
            CGRect(x: 45, y: 50, width: 10, height: 10),
            CGRect(x: 75, y: 75, width: 10, height: 10),
            CGRect(x: 15, y: 95, width: 70, height: 0)
            ]
        )
    }

    func testWithPaddingHoriztonal() {
        let layout = LinearLayout()
        layout.orientation = .horizontal
        layout.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        layout.padding = 10

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = .top
            view.margin = 10
        }))
        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = .center
            view.margin = 10
        }))
        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = .bottom
            view.margin = 5
        }))
        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = .fill
            view.margin = 5
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }), [
            CGRect(x: 20, y: 20, width: 10, height: 10),
            CGRect(x: 50, y: 45, width: 10, height: 10),
            CGRect(x: 75, y: 75, width: 10, height: 10),
            CGRect(x: 95, y: 15, width: 0, height: 70)
            ]
        )
    }

    func testContentGravity() {
        let layout = LinearLayout()
        layout.orientation = .horizontal
        layout.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        layout.padding = 10

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = .top
            view.margin = 5
        }))
        layout.addSubview(BaseView().apply({ (view) in
            view.layoutSize = CGSize(width: 10, height: 10)
            view.layoutGravity = .fill
            view.margin = 5
        }))

        layout.contentGravity = [.start, .top]
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }), [
            CGRect(x: 15, y: 15, width: 10, height: 10),
            CGRect(x: 35, y: 15, width: 10, height: 70)
            ]
        )

        layout.contentGravity = [.end, .top]
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }), [
            CGRect(x: 55, y: 15, width: 10, height: 10),
            CGRect(x: 75, y: 15, width: 10, height: 70)
            ]
        )

        layout.contentGravity = [.centerHorizontal, .top]
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }), [
            CGRect(x: 35, y: 15, width: 10, height: 10),
            CGRect(x: 55, y: 15, width: 10, height: 70)
            ]
        )
    }

    func testSizeThatFits() {
        let layout = LinearLayout()
        layout.orientation = .horizontal

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutWeight = 1
            view.layoutSize = CGSize(width: 50, height: 50)
            view.margin = 5
        }))
        XCTAssertEqual(layout.sizeThatFits(CGSize(width: 200, height: CGFloat.greatestFiniteMagnitude)),
                       CGSize(width: 200, height: 60))

        layout.padding = 10
        let measuredSize = layout.sizeThatFits(CGSize(width: 200, height: CGFloat.greatestFiniteMagnitude))
        XCTAssertEqual(measuredSize,
                       CGSize(width: 200, height: 80))

        layout.bounds = CGRect(origin: .zero, size: measuredSize)
        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }), [
            CGRect(x: 15, y: 15, width: 170, height: 50)
            ]
        )

        layout.addSubview(BaseView().apply({ (view) in
            view.layoutWeight = 3
            view.layoutSize = CGSize(width: 0, height: 100)
            view.margin = 10
        }))

        layout.layoutSubviews()
        XCTAssertEqual(layout.subviews.map({ $0.frame }), [
            CGRect(x: 15, y: 15, width: 37.5, height: 50),
            CGRect(x: 67.5, y: 20, width: 112.5, height: 40)
            ]
        )
        XCTAssertEqual(layout.sizeThatFits(CGSize(width: 200, height: CGFloat.greatestFiniteMagnitude)),
                       CGSize(width: 200, height: 140))
    }
}
// swiftlint:enable type_body_length file_length
