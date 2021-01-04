import oneHookLibrary
import UIKit


private class DemoCollectionViewCell: UICollectionViewCell {

    let titleLabel = EDLabel().apply {
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(titleLabel)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func bind(_ uiModel: UIModel) {
        contentView.backgroundColor = uiModel.color
        titleLabel.text = "ID\(uiModel.id)\n\(Int(uiModel.height))"
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.matchParent()
    }
}

private struct UIModel {
    static var ID: Int = 0
    var id: Int
    var color: UIColor
    var height: CGFloat

    static func fake() -> UIModel {
        Self.ID += 1
        return UIModel(id: self.ID, color: UIColor.random(), height: CGFloat.random(in: 50..<200))
    }
}

class StaggerGridLayoutDemoViewController: BaseDemoViewController {

    let collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: StaggeredCollectionViewLayout())
    let addItemButton = EDButton().apply {
        $0.layoutSize = CGSize(width: 0, height: dp(50))
        $0.layoutGravity = [.fillHorizontal, .bottom]
        $0.backgroundColor = .black
        $0.setTitle("Add Items", for: .normal)
        $0.layer.cornerRadius = dp(25)
        $0.layer.masksToBounds = true
        $0.margin = Dimens.marginMedium
        $0.marginBottom = max(UIScreen.safeArea.bottom, Dimens.marginMedium)
    }

    fileprivate var uiModels = [UIModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.disableAutomaticInsetAdjustment()
        view.insertSubview(collectionView.apply {
            $0.backgroundColor = .white
        }, belowSubview: toolbar)

        collectionView.register(DemoCollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        (collectionView.collectionViewLayout as? StaggeredCollectionViewLayout)?.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: toolbar.contentContainerOffset + toolbar.toolbarHeight,
                                                   left: dp(8),
                                                   bottom: dp(50),
                                                   right: dp(8))

        view.addSubview(addItemButton)
        addItemButton.addTarget(self, action: #selector(addItemButtonPressed), for: .touchUpInside)

    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.matchParent()
    }

    @objc private func addItemButtonPressed() {
        let startIndex = uiModels.count
        var toInsert = [IndexPath]()
        for i in 0..<50 {
            uiModels.append(UIModel.fake())
            toInsert.append(IndexPath(row: startIndex + i, section: 0))
        }
        print("XXX new item size", uiModels.count)
        collectionView.performBatchUpdates {
            collectionView.insertItems(at: toInsert)
        } completion: { (completed) in
            print("xxx batch udpate completed")
        }

//        collectionView.reloadData()
    }
}

extension StaggerGridLayoutDemoViewController: UICollectionViewDelegate, UICollectionViewDataSource, StaggeredColleciontViewLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath, cellWidth: CGFloat) -> CGFloat {
        uiModels[indexPath.row].height
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return uiModels.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        (cell as? DemoCollectionViewCell)?.bind(uiModels[indexPath.row])
        return cell
    }
}
