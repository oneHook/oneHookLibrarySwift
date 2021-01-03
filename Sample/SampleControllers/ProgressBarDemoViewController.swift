import oneHookLibrary
import UIKit

class ProgressBarDemoViewController: BaseScrollableDemoViewController {

    var linearProgressBar1 = LinearProgressBar()
    var progressRing1 = ProgressRing()
    var progressRing2 = ProgressRing()
    var progressRing3 = ProgressRing()

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

        contentLinearLayout.addSubview(FrameLayout().apply {
            $0.marginTop = Dimens.marginMedium
            $0.layoutGravity = .centerHorizontal
            $0.addSubview(
                progressRing1.apply {
                    $0.layoutSize = CGSize(width: dp(128), height: dp(128))
                    $0.addProgress(key: "main",
                                   progress: 1.0,
                                   color: .red)
                    $0.addProgress(key: "sub",
                                   progress: 1.0,
                                   color: .green)
                }
            )
            $0.addSubview(
                progressRing2.apply {
                    $0.padding = dp(8)
                    $0.layoutSize = CGSize(width: dp(128), height: dp(128))

                    $0.addProgress(key: "main",
                                   progress: 1.0,
                                   color: .cyan)
                    $0.addProgress(key: "sub",
                                   progress: 1.0,
                                   color: .purple)
                }
            )
            $0.addSubview(
                progressRing3.apply {
                    $0.padding = dp(16)
                    $0.layoutSize = CGSize(width: dp(128), height: dp(128))

                    $0.addProgress(key: "main",
                                   progress: 1.0,
                                   color: .gray)
                    $0.addProgress(key: "sub",
                                   progress: 1.0,
                                   color: .darkGray)
                }
            )
        })

        contentLinearLayout.addSubview(
            EDButton().apply {
                $0.marginTop = Dimens.marginMedium
                $0.layoutGravity = [.fillHorizontal]
                $0.setTitle("Random Progress", for: .normal)
                $0.setTitleColor(.blue, for: .normal)
                $0.addTarget(self, action: #selector(randomButtonPressed), for: .touchUpInside)
            }
        )

    }

    @objc private func randomButtonPressed() {
        linearProgressBar1.also {
            $0.updateProgress(key: "main", progress: CGFloat(Float.random(min: 0, max: 1)))
            $0.updateProgress(key: "sub", progress: CGFloat(Float.random(min: 0, max: 1)))
        }
        progressRing1.also {
            $0.updateProgress(key: "main", progress: CGFloat(Float.random(min: 0, max: 1)))
            $0.updateProgress(key: "sub", progress: CGFloat(Float.random(min: 0, max: 1)))
        }
        progressRing2.also {
            $0.updateProgress(key: "main", progress: CGFloat(Float.random(min: 0, max: 1)))
            $0.updateProgress(key: "sub", progress: CGFloat(Float.random(min: 0, max: 1)))
        }
        progressRing3.also {
            $0.updateProgress(key: "main", progress: CGFloat(Float.random(min: 0, max: 1)))
            $0.updateProgress(key: "sub", progress: CGFloat(Float.random(min: 0, max: 1)))
        }
    }
}
