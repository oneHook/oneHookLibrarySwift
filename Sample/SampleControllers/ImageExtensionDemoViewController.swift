import oneHookLibrary
import UIKit

class ImageExtensionDemoViewController: BaseScrollableDemoViewController {

    private lazy var imageView = EDImageView().apply {
        $0.layoutGravity = .centerHorizontal
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.backgroundColor = .gray
        $0.layoutSize = CGSize(width: dp(350), height: dp(350))
    }

    private lazy var statusLabel = EDLabel().apply {
        $0.layoutGravity = .centerHorizontal
        $0.font = Fonts.regular(Fonts.fontSizeMedium)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }

    private lazy var pickImageButon = EDButton().apply {
        $0.layoutSize = CGSize(width: dp(200), height: dp(56))
        $0.layoutGravity = .centerHorizontal
        $0.setImage(UIImage.solid(.white), for: .normal)
        $0.setTitle(missing("Add Image"), for: .normal)
        $0.addTarget(self, action: #selector(pickButtonPressed), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarTitle = "Image Extension"

        contentLinearLayout.addSubview(imageView)
        contentLinearLayout.addSubview(statusLabel)
        contentLinearLayout.addSubview(pickImageButon)
        for i in 0..<5 {
            contentLinearLayout.addSubview(EDImageView().apply {
                $0.layoutGravity = .centerHorizontal
                $0.layoutSize = CGSize(width: dp(200), height: dp(200))
                $0.image = UIImage(named: "ic_emoji")?.alpha(0.2 * CGFloat(i))
                $0.tintColor = UIColor.red
            })
        }
    }

    @objc private func pickButtonPressed() {
        let controller = UIImagePickerController()
        controller.delegate = self
        present(controller, animated: true, completion: nil)
    }

    private func processUrl(_ url: URL) {
        let image = UIImage.downSampled(
            url,
            maxPixelDimension: 2000
        )!

        print("XXX before size", image.size)
//        let newImage = UIImage.resizeImage(image: image, shortEdgeTo: 600)!
        let newImage = UIImage.crop(
            image: image,
            targetRect: CGRect(x: 0, y: 0, width: 305, height: 305),
            maximumSize: 200
        )
        print("XXX after size", newImage.size)
        self.imageView.image = newImage


//        self.imageView.image = newImage
//        let destinationUrl = FileUtility.getOrCreatePrivateFileUrl(name: "out.jpeg")
//        UIImage.downSample(url, maxPixelDimension: 1600, destinationUrl: destinationUrl)
//        let text = """
//Loaded Image size \(image!.size) \(image!.scale)
//Saved Image size \(FileUtility.getFileSize(url: destinationUrl)!)
//"""
//        statusLabel.text = text
//        contentLinearLayout.setNeedsLayout()
    }
}

extension ImageExtensionDemoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        dismiss(animated: true, completion: {
            if let imageURL = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                self.processUrl(imageURL)
            }
        })
    }
}
