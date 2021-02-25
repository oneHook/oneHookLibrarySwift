import UIKit
import oneHookLibrary

class StackLayoutDemoViewController: BaseScrollableDemoViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        toolbarTitle = "StackLayout Demo"

        contentLinearLayout.addSubview(EDLabel.h2().apply {
            $0.text = "Horizontal 0 spacing"
        })
        contentLinearLayout.addSubview(StackLayout().apply {
            $0.orientation = .horizontal
            $0.layer.borderColor = UIColor.red.cgColor
            $0.layer.borderWidth = dp(1)
            $0.paddingStart = dp(10)
            $0.paddingEnd = dp(20)
            $0.paddingTop = dp(5)
            $0.paddingBottom = dp(30)

            for i in 0..<5 {
                $0.addSubview(EDLabel().apply {
                    $0.layoutGravity = [.centerVertical]
                    let length = 20 * CGFloat(i + 1)
                    $0.layoutSize = CGSize(width: length, height: length)
                    $0.layer.cornerRadius = length / 2
                    $0.layer.masksToBounds = true
                    $0.text = String(i)
                    $0.backgroundColor = UIColor.random()
                    $0.textAlignment = .center
                })
            }
        })

        contentLinearLayout.addSubview(EDLabel.h2().apply {
            $0.text = "Vertical 0 spacing"
        })
        contentLinearLayout.addSubview(StackLayout().apply {
            $0.orientation = .vertical
            $0.layer.borderColor = UIColor.red.cgColor
            $0.layer.borderWidth = dp(1)
            $0.paddingStart = dp(10)
            $0.paddingEnd = dp(20)
            $0.paddingTop = dp(5)
            $0.paddingBottom = dp(30)

            for i in 0..<5 {
                $0.addSubview(EDLabel().apply {
                    $0.layoutGravity = [.centerHorizontal]
                    let length = 20 * CGFloat(i + 1)
                    $0.layoutSize = CGSize(width: length, height: length)
                    $0.layer.cornerRadius = length / 2
                    $0.layer.masksToBounds = true
                    $0.text = String(i)
                    $0.backgroundColor = UIColor.random()
                    $0.textAlignment = .center
                })
            }
        })

        contentLinearLayout.addSubview(EDLabel.h2().apply {
            $0.text = "Vertical test"
        })
        contentLinearLayout.addSubview(StackLayout().apply { (layout) in
            layout.layer.borderColor = UIColor.red.cgColor
            layout.layer.borderWidth = dp(1)
            layout.orientation = .vertical
            layout.layoutSize = CGSize(width: 100, height: 100)
            layout.paddingStart = 1
            layout.paddingTop = 2
            layout.paddingEnd = 3
            layout.paddingBottom = 4

            layout.addSubview(BaseView().apply({ (view) in
                view.layoutSize = CGSize(width: 10, height: 10)
                view.layoutGravity = .start
                view.marginEnd = 5
                view.backgroundColor = .red
            }))
            layout.addSubview(BaseView().apply({ (view) in
                view.layoutSize = CGSize(width: 10, height: 10)
                view.layoutGravity = .center
                view.marginStart = 5
                view.backgroundColor = .red
            }))
            layout.addSubview(BaseView().apply({ (view) in
                view.layoutSize = CGSize(width: 10, height: 10)
                view.layoutGravity = .end
                view.marginBottom = 5
                view.backgroundColor = .red
            }))
        })

        contentLinearLayout.addSubview(EDLabel.h2().apply {
            $0.text = "Horizontal test"
        })
        contentLinearLayout.addSubview(StackLayout().apply { (layout) in
            layout.layer.borderColor = UIColor.red.cgColor
            layout.layer.borderWidth = dp(1)
            layout.orientation = .horizontal
            layout.layoutSize = CGSize(width: 100, height: 100)
            layout.paddingStart = 1
            layout.paddingTop = 2
            layout.paddingEnd = 3
            layout.paddingBottom = 4

            layout.addSubview(BaseView().apply({ (view) in
                view.layoutSize = CGSize(width: 10, height: 10)
                view.layoutGravity = .top
                view.marginEnd = 5
                view.backgroundColor = .red
            }))
            layout.addSubview(BaseView().apply({ (view) in
                view.layoutSize = CGSize(width: 10, height: 10)
                view.layoutGravity = .center
                view.marginStart = 5
                view.backgroundColor = .red
            }))
            layout.addSubview(BaseView().apply({ (view) in
                view.layoutSize = CGSize(width: 10, height: 10)
                view.layoutGravity = .bottom
                view.marginBottom = 5
                view.backgroundColor = .red
            }))
        })

        contentLinearLayout.addSubview(EDLabel.h2().apply {
            $0.marginTop = Dimens.marginMedium
            $0.text = "Horizontal negative spacing"
        })
        contentLinearLayout.addSubview(StackLayout().apply {
            $0.orientation = .horizontal
            $0.padding = dp(10)
            $0.spacing = -dp(15)

            for i in 0..<5 {
                $0.addSubview(EDLabel().apply {
                    $0.layoutGravity = [.centerVertical]
                    $0.layoutSize = CGSize(width: dp(50), height: dp(50))
                    $0.layer.cornerRadius = dp(25)
                    $0.layer.masksToBounds = true
                    $0.text = String(i)
                    $0.backgroundColor = UIColor.random()
                    $0.textAlignment = .center
                })
            }
        })

        contentLinearLayout.addSubview(EDLabel.h2().apply {
            $0.marginTop = Dimens.marginMedium
            $0.text = "Horizontal negative spacing"
        })
        contentLinearLayout.addSubview(StackLayout().apply {
            $0.orientation = .horizontal
            $0.padding = dp(10)
            $0.spacing = -dp(25)

            for i in 0..<5 {
                $0.addSubview(EDLabel().apply {
                    $0.layoutGravity = [.centerVertical]
                    $0.layoutSize = CGSize(width: dp(50), height: dp(50))
                    $0.layer.cornerRadius = dp(25)
                    $0.layer.masksToBounds = true
                    $0.text = String(i)
                    $0.backgroundColor = UIColor.random()
                    $0.textAlignment = .center
                })
            }
        })

        contentLinearLayout.addSubview(EDLabel.h2().apply {
            $0.marginTop = Dimens.marginMedium
            $0.text = "Vertical 0 spacing"
        })
        contentLinearLayout.addSubview(StackLayout().apply {
            $0.orientation = .vertical
            $0.padding = dp(10)
            $0.spacing = -dp(25)

            for i in 0..<5 {
                $0.addSubview(EDLabel().apply {
                    $0.layoutGravity = [.centerVertical]
                    $0.layoutSize = CGSize(width: dp(50), height: dp(50))
                    $0.layer.cornerRadius = dp(25)
                    $0.layer.masksToBounds = true
                    $0.text = String(i)
                    $0.backgroundColor = UIColor.random()
                    $0.textAlignment = .center
                })
            }
        })

        contentLinearLayout.addSubview(EDLabel.h2().apply {
            $0.marginTop = Dimens.marginMedium
            $0.text = "Vertical 10 spacing"
        })
        contentLinearLayout.addSubview(StackLayout().apply {
            $0.orientation = .vertical
            $0.padding = dp(10)
            $0.spacing = dp(10)

            for i in 0..<5 {
                $0.addSubview(EDLabel().apply {
                    $0.layoutGravity = [.centerVertical]
                    $0.layoutSize = CGSize(width: dp(50), height: dp(50))
                    $0.layer.cornerRadius = dp(25)
                    $0.layer.masksToBounds = true
                    $0.text = String(i)
                    $0.backgroundColor = UIColor.random()
                    $0.textAlignment = .center
                })
            }
        })
    }
}
