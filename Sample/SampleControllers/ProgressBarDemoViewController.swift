import oneHookLibrary
import UIKit

class ProgressBarDemoViewController: BaseScrollableDemoViewController {

    var linearProgressBar1 = LinearProgressBar()

    override func viewDidLoad() {
        super.viewDidLoad()

        toolbarTitle = "Progress Bar"

        contentLinearLayout.addSubview(
            linearProgressBar1.apply {
                $0.backgroundColor = .cyan
                $0.padding = Dimens.marginSmall
                $0.marginTop = Dimens.marginMedium
                $0.addProgress(
                    key: "background",
                    progress: 1,
                    color: .lightGray,
                    cornerRadius: $0.thickness / 2
                )
                $0.addProgress(
                    key: "main",
                    progress: 0.5,
                    color: .red,
                    cornerRadius: $0.thickness / 2,
                    borderColor: .white
                )
                $0.addProgress(
                    key: "sub",
                    progress: 0.5,
                    color: .yellow,
                    cornerRadius: $0.thickness / 2,
                    borderColor: .white
                )
            }
        )

        contentLinearLayout.addSubview(
            EDButton().apply {
                $0.layoutGravity = [.fillHorizontal]
                $0.setTitle("Random Progress", for: .normal)
                $0.setTitleColor(.blue, for: .normal)
                $0.addTarget(self, action: #selector(randomButtonPressed), for: .touchUpInside)
            }
        )
    }

    @objc private func randomButtonPressed() {
        self.linearProgressBar1.updateProgress(
            key: "main",
            progress: CGFloat(Float.random(min: 0, max: 1))
        )
        self.linearProgressBar1.updateProgress(
            key: "sub",
            progress: CGFloat(Float.random(min: 0, max: 1))
        )
    }
}
