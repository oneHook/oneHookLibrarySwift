import oneHookLibrary
import UIKit

class ColorPickerViewDemoViewController: BaseScrollableDemoViewController {

    let colorPicker1 = ColorPickerView().apply {
        $0.elementSize = 1
    }

    let colorPicker2 = ColorPickerView().apply {
        $0.elementSize = 10
    }

    let colorPicker3 = ColorPickerView().apply {
        $0.elementSize = 50
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarTitle = "Color Picker"
        contentLinearLayout.addSubview(colorPicker1)
        contentLinearLayout.addSubview(colorPicker2)
        contentLinearLayout.addSubview(colorPicker3)
    }

}
