import UIKit
import oneHookLibrary

class LinearLayoutDemoViewController: BaseScrollableDemoViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        toolbarTitle = "LinearLayout Demo"

        contentLinearLayout.addSubview(EDLabel().apply {
            $0.text = "Horizontal LinearLayout"
            $0.marginBottom = Dimens.marginMedium
        })

        contentLinearLayout.addSubview(LinearLayout().apply {
            $0.orientation = .horizontal
            $0.layoutGravity = [.fillHorizontal]
            $0.layoutSize = CGSize(width: 1, height: dp(150))
            $0.padding = dp(10)
            $0.backgroundColor = .gray

            $0.addSubview(EDLabel().apply {
                $0.textAlignment = .center
                $0.adjustsFontSizeToFitWidth = true
                $0.layoutSize = CGSize(width: dp(50), height: dp(50))
                $0.text = "Bottom"
                $0.layoutGravity = [.bottom]
                $0.backgroundColor = .white
                $0.marginEnd = Dimens.marginMedium
            })

            $0.addSubview(EDLabel().apply {
                $0.textAlignment = .center
                $0.adjustsFontSizeToFitWidth = true
                $0.layoutSize = CGSize(width: dp(50), height: dp(50))
                $0.text = "Center"
                $0.layoutGravity = [.centerVertical]
                $0.backgroundColor = .white
                $0.marginEnd = Dimens.marginMedium
            })

            $0.addSubview(EDLabel().apply {
                $0.textAlignment = .center
                $0.adjustsFontSizeToFitWidth = true
                $0.layoutSize = CGSize(width: dp(50), height: dp(50))
                $0.text = "Top"
                $0.layoutGravity = [.top]
                $0.backgroundColor = .white
                $0.marginEnd = Dimens.marginMedium
            })
        })

        contentLinearLayout.addSubview(EDLabel().apply {
            $0.text = "Vertical LinearLayout"
            $0.marginTop = Dimens.marginMedium
            $0.marginBottom = Dimens.marginMedium
        })

        contentLinearLayout.addSubview(LinearLayout().apply {
            $0.orientation = .vertical
            $0.layoutGravity = [.fillHorizontal]
            $0.padding = dp(10)
            $0.backgroundColor = .gray

            $0.addSubview(EDLabel().apply {
                $0.textAlignment = .center
                $0.adjustsFontSizeToFitWidth = true
                $0.layoutSize = CGSize(width: dp(50), height: dp(50))
                $0.text = "Start"
                $0.layoutGravity = [.start]
                $0.backgroundColor = .white
                $0.marginEnd = Dimens.marginMedium
            })

            $0.addSubview(EDLabel().apply {
                $0.textAlignment = .center
                $0.adjustsFontSizeToFitWidth = true
                $0.layoutSize = CGSize(width: dp(50), height: dp(50))
                $0.text = "Center"
                $0.layoutGravity = [.centerHorizontal]
                $0.backgroundColor = .white
                $0.marginEnd = Dimens.marginMedium
            })

            $0.addSubview(EDLabel().apply {
                $0.textAlignment = .center
                $0.adjustsFontSizeToFitWidth = true
                $0.layoutSize = CGSize(width: dp(50), height: dp(50))
                $0.text = "End"
                $0.layoutGravity = [.end]
                $0.backgroundColor = .white
                $0.marginEnd = Dimens.marginMedium
            })
        })

        contentLinearLayout.addSubview(EDLabel().apply {
            $0.marginTop = Dimens.marginMedium
            $0.numberOfLines = 0
            $0.backgroundColor = .lightGray
            $0.text = """
                Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?
                """
        })
    }
}
