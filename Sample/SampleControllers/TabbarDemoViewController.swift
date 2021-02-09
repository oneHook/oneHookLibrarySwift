import oneHookLibrary
import UIKit

private class SimpleScrollView: EDScrollView {

    override func commonInit() {
        super.commonInit()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentSize = CGSize(width: bounds.width * 3, height: 1)
    }
}

private class MyTabItemView: TabItemView {

    private let dotView = BaseView().apply {
        $0.bounds = CGRect(origin: .zero, size: CGSize(width: dp(12), height: dp(12)))
        $0.layer.cornerRadius = dp(6)
        $0.backgroundColor = .red
        $0.shouldSkip = true
    }

    override func commonInit() {
        super.commonInit()
        stackLayout.addSubview(dotView)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: .defaultAnimationSmall, animations: {
            self.layer.anchorPoint = .init(x: 0.5, y: 0.5)
            self.layer.transform = CATransform3DMakeScale(0.9, 0.9, 1)
        })
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: .defaultAnimationSmall, animations: {
            self.layer.transform = CATransform3DIdentity
        })
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: .defaultAnimationSmall, animations: {
            self.layer.transform = CATransform3DIdentity
        })
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        dotView.center = imageView.value?.center ?? .zero
    }
}

class TabbarDemoViewController: BaseScrollableDemoViewController, UIScrollViewDelegate {

    let tab1 = TabLayoutView().apply {
        $0.layoutGravity = [.fillHorizontal]
        $0.tintColorNormal = .white
        $0.tintColorHighlight = .red
    }

    let tab2 = TabLayoutView().apply {
        $0.layoutGravity = [.fillHorizontal]
        $0.marginTop = Dimens.marginMedium
    }

    let tab3 = TabLayoutView().apply {
        $0.layoutGravity = [.fillHorizontal]
        $0.marginTop = Dimens.marginMedium
        $0.tintColorNormal = .yellow
        $0.tintColorHighlight = .blue
    }

    let tab4 = TabLayoutView().apply {
        $0.layoutGravity = [.fillHorizontal]
        $0.marginTop = Dimens.marginMedium
        $0.tintColorNormal = .yellow
        $0.tintColorHighlight = .blue
    }

    private let horizontalScrollView = SimpleScrollView().apply {
        $0.isPagingEnabled = true
        $0.marginTop = Dimens.marginMedium
        $0.backgroundColor = .white
        $0.layoutGravity = [.fillHorizontal]
        $0.layoutSize = CGSize(width: 0, height: dp(300))
    }

    private func createIcon() -> UIImage {
        UIImage(color: .blue,
                size: CGSize(width: dp(10), height: dp(10)))!.withRenderingMode(.alwaysTemplate)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarTitle = "TabBar Demo View Controller"

        horizontalScrollView.delegate = self

        contentLinearLayout.addSubview(tab1.apply {
            $0.addTab(TabItemView(uiModel: TabItemUIModel(text: "Tab1".attributedString())))
            $0.addTab(TabItemView(uiModel: TabItemUIModel(text: "Tab2".attributedString())))
            $0.addTab(TabItemView(uiModel: TabItemUIModel(text: "Tab3".attributedString())))
        })
        tab2.tabHeight = dp(100)
        contentLinearLayout.addSubview(tab2.apply {
            $0.addTab(TabItemView(
                        uiModel: TabItemUIModel(
                            image: createIcon(),
                            text: "Tab1".attributedString())))
            $0.addTab(TabItemView(
                        uiModel: TabItemUIModel(
                            image: createIcon(),
                            text: "Tab2".attributedString())))
            $0.addTab(TabItemView(
                        uiModel: TabItemUIModel(
                            image: createIcon(),
                            text: "Tab3".attributedString())))
        })


        tab3.tabHeight = dp(100)
        contentLinearLayout.addSubview(tab3.apply {
            $0.addTab(TabItemView(
                        uiModel: TabItemUIModel(
                            image: createIcon(),
                            text: "Tab1".attributedString(font: UIFont(name: "HelveticaNeue-Light", size: 16)),
                            orientation: .horizontal
                        )))
            $0.addTab(TabItemView(
                        uiModel: TabItemUIModel(
                            image: createIcon(),
                            text: "Tab2".attributedString(font: UIFont(name: "HelveticaNeue-Light", size: 16)),
                            orientation: .horizontal
                        )))
            $0.addTab(TabItemView(
                        uiModel: TabItemUIModel(
                            image: createIcon(),
                            text: "Tab3".attributedString(font: UIFont(name: "HelveticaNeue-Light", size: 16)),
                            orientation: .horizontal
                        )))
        })

        tab4.tabHeight = dp(100)
        contentLinearLayout.addSubview(tab4.apply {
            $0.addTab(MyTabItemView(
                        uiModel: TabItemUIModel(
                            image: createIcon(),
                            text: "Tab1".attributedString(font: UIFont(name: "HelveticaNeue-Light", size: 16)),
                            orientation: .horizontal
                        )))
            $0.addTab(MyTabItemView(
                        uiModel: TabItemUIModel(
                            image: createIcon(),
                            text: "Tab2".attributedString(font: UIFont(name: "HelveticaNeue-Light", size: 16)),
                            orientation: .horizontal
                        )))
            $0.addTab(MyTabItemView(
                        uiModel: TabItemUIModel(
                            image: createIcon(),
                            text: "Tab3".attributedString(font: UIFont(name: "HelveticaNeue-Light", size: 16)),
                            orientation: .horizontal
                        )))
        })

        contentLinearLayout.addSubview(horizontalScrollView)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let progress = scrollView.contentOffset.x / scrollView.bounds.width
        tab1.setSelectedIndex(progress, animated: false)
        tab2.setSelectedIndex(progress, animated: false)
        tab3.setSelectedIndex(progress, animated: false)
        tab4.setSelectedIndex(progress, animated: false)
    }
}
