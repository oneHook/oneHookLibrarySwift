import oneHookLibrary
import UIKit

class TimePickerViewDemoViewController: BaseScrollableDemoViewController {

    let timePicker1 = TimePickerView().apply {
        $0.layoutSize = CGSize(width: 0, height: dp(300))
        $0.layoutGravity = [.fillHorizontal]
        $0.backgroundColor = .white
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarTitle = "Time Picker View"
        contentLinearLayout.addSubview(timePicker1)
    }
}
