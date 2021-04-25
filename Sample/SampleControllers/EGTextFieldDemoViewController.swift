import oneHookLibrary
import UIKit

private let message = """
It is the ninth year of summer[N 1] Seven-year-old Bran Stark is traveling with a party of twenty men, including his father Lord Eddard Stark, to see the king's justice done. This is the first time that he is allowed to join. Bran's older brother Robb thinks the man to be executed must be a wildling sworn to Mance Rayder, the King-Beyond-the-Wall, which makes Bran think of the tales Old Nan has told him about wildlings.

The offender turns out to be an old man dressed in the ragged blacks of the Night's Watch who has lost his ears and a finger to frostbite.[N 2] Lord Eddard questions the man briefly. Then two guardsmen drag the man to the stump of a tree and Theon Greyjoy, Eddard's ward, brings Eddard his Valyrian steel sword, Ice. Eddard pronounces the sentence (desertion of the Night's Watch is punished by death) and raises the blade. Jon Snow, Bran's bastard brother, reminds Bran not look away and so Bran watches as his father strikes off the man's head with a single stroke. The head lands near Theon, who laughs and kicks it away. Jon calls Theon an ass under his breath and compliments Bran on his poise during the execution.
"""

class EGTextFieldDemoViewController: BaseScrollableDemoViewController {

    let textField1 = EGTextField().apply {
        $0.layoutGravity = .fillHorizontal
        $0.font = Fonts.regular(Fonts.fontSizeMedium)
        $0.borderWidth = dp(1)
        $0.colorNormal = UIColor.red
        $0.colorActive = UIColor.blue
        $0.cornerRadius = dp(0)
        $0.attributedPlaceholder = "Username".attributedString(
            textColor: UIColor.lightGray
        )
        $0.paddingStart = Dimens.marginMedium
    }

    let textField2 = EGTextField().apply {
        $0.marginTop = Dimens.marginMedium
        $0.layoutGravity = .fillHorizontal
        $0.layoutSize = CGSize(width: 1, height: dp(50))
        $0.font = Fonts.regular(Fonts.fontSizeLarge)
        $0.borderWidth = dp(2)
        $0.colorNormal = UIColor.lightGray
        $0.colorActive = UIColor.white
        $0.cornerRadius = dp(15)
        $0.layer.cornerRadius = Dimens.standardCornerRadius

        $0.paddingStart = Dimens.marginMedium
        $0.paddingEnd = Dimens.marginMedium

        $0.rightContainer.getOrMake().also {
            $0.spacing = dp(10)
            
            $0.addSubview(BaseView().apply {
                $0.backgroundColor = .white
                $0.layoutSize = CGSize(width: dp(10), height: dp(10))
            })

            $0.addSubview(BaseView().apply {
                $0.backgroundColor = .white
                $0.layoutSize = CGSize(width: dp(10), height: dp(10))
            })
        }

        $0.attributedPlaceholder = "Address".attributedString(
            letterSpacing: dp(1), textColor: UIColor.lightGray
        )
    }

    let textView1 = EGTextView().apply {
        $0.marginTop = Dimens.marginMedium
        $0.layoutSize = CGSize(width: 0, height: dp(100))
        $0.layoutGravity = .fillHorizontal
        $0.borderWidth = dp(1)
        $0.colorNormal = UIColor.red
        $0.colorActive = UIColor.blue
        $0.cornerRadius = dp(0)
        $0.placeholder = "Enter a note"
        $0.font = Fonts.regular(Fonts.fontSizeMedium)

        $0.setPlaceholderTextColor(.lightGray)

        $0.text = message
    }



    let textView2 = EDTextView().apply {
        $0.marginTop = Dimens.marginMedium
        $0.layoutSize = CGSize(width: 0, height: dp(100))
        $0.layoutGravity = .fillHorizontal
//        $0.borderWidth = dp(1)
//        $0.colorNormal = UIColor.red
//        $0.colorActive = UIColor.blue
//        $0.cornerRadius = dp(0)
        $0.placeholder = "Enter a note"
        $0.font = Fonts.regular(Fonts.fontSizeMedium)
        $0.setPlaceholderTextColor(.lightGray)
        $0.text = message
        $0.backgroundColor = .red
        $0.padding = Dimens.marginSmall
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarTitle = "EGTextField View Demo View Controller"

        contentLinearLayout.addSubview(textField1)
        contentLinearLayout.addSubview(textField2)
        contentLinearLayout.addSubview(textView1)
        contentLinearLayout.addSubview(textView2)
    }

}
