import oneHookLibrary
import UIKit

class ViewPagerDemoViewController: BaseScrollableDemoViewController, BaseViewPagerDatasource {

    var views = [Int: UIView]()

    func numberOfItems() -> Int {
        10
    }

    func viewForItemAt(index: Int) -> UIView {
        views[index] ?? EDLabel().apply {
            $0.backgroundColor = UIColor.random()
            $0.textAlignment = .center
            $0.font = UIFont.systemFont(ofSize: 20)
            $0.text = String(index)
            $0.layer.cornerRadius = Dimens.standardCornerRadius
            $0.layer.masksToBounds = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarTitle = "ViewPager"

        contentLinearLayout.addSubview(ViewPager().apply {
            $0.layoutGravity = [.fillHorizontal]
            $0.layoutSize = CGSize(width: 1, height: dp(200))
            $0.datasource = self
            $0.backgroundColor = .white
        })
    }
}
