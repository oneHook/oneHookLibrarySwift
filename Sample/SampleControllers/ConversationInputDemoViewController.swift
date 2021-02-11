import UIKit
import oneHookLibrary

private struct ConversationItemUIModel {
    let text: String
}

private class ConversationCell: SelectableTableViewCell {

    private let linearLayout = LinearLayout().apply {
        $0.padding = Dimens.marginMedium
        $0.orientation = .horizontal
    }

    private let conversationTextLabel = EDLabel().apply {
        $0.font = Fonts.regular(Fonts.fontSizeLarge)
    }

    override func commonInit() {
        super.commonInit()
        contentView.addSubview(linearLayout.apply {
            $0.addSubview(conversationTextLabel)
        })
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        linearLayout.sizeThatFits(size)
    }

    func bind(_ uiModel: ConversationItemUIModel) {
        conversationTextLabel.text = uiModel.text
    }
}

private class MyInputView: ConversationInputView {

    let captureButton = EDButton().apply {
        $0.layoutGravity = [.centerVertical]
        $0.marginEnd = dp(10)
        $0.setImage(
            UIImage(color: .red, size: CGSize(width: dp(10), height: dp(10))),
            for: .normal
        )
        $0.layer.cornerRadius = dp(5)
        $0.layer.masksToBounds = true
    }

    let attachmentButton = EDButton().apply {
        $0.layoutGravity = [.centerVertical]
        $0.marginStart = dp(10)
        $0.setImage(
            UIImage(color: .blue, size: CGSize(width: dp(10), height: dp(10))),
            for: .normal
        )
        $0.layer.cornerRadius = dp(5)
        $0.layer.masksToBounds = true
    }

    let pictureButton = EDButton().apply {
        $0.layoutGravity = [.centerVertical]
        $0.marginStart = dp(10)
        $0.setImage(
            UIImage(color: .blue, size: CGSize(width: dp(10), height: dp(10))),
            for: .normal
        )
        $0.layer.cornerRadius = dp(5)
        $0.layer.masksToBounds = true
    }

    override func commonInit() {
        super.commonInit()
        paddingStart = dp(10)
        paddingEnd = dp(10)
        layer.borderWidth = dp(1)
        layer.borderColor = UIColor.white.cgColor
        layer.cornerRadius = dp(5)
        shouldSkip = true
        addViewBeforeTextView(captureButton)
        addViewAfterTextView(attachmentButton)
        addViewAfterTextView(pictureButton)
    }
}

class ConversationInputDemoViewController: BaseDemoViewController, KeyboardObservable {

    private var items: [ConversationItemUIModel] = [
        ConversationItemUIModel(text: "Hello"),
        ConversationItemUIModel(text: "Yes")
    ]

    let tableView = EDTableView().apply {
        $0.layoutGravity = [.fill]
        $0.register(ConversationCell.self, forCellReuseIdentifier: "Cell")
        $0.keyboardDismissMode = .onDrag
    }

    private lazy var conversationInputView = MyInputView().apply {
        $0.requiresHeight = { [weak self] (height) in
            UIView.animate(withDuration: .defaultAnimationSmall, animations: {
                self?.layoutInputView()
            })
        }
    }

    let keyboardObserver = KeyboardObserver()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .defaultBackgroundColor
        toolbarTitle = "Conversation Input Demo"
        tableView.also {
            view.insertSubview($0, belowSubview: toolbar)
            $0.contentInset = UIEdgeInsets(
                top: toolbar.intrinsicContentSize.height,
                left: 0,
                bottom: 0,
                right: 0
            )
            $0.contentOffset = CGPoint(x: 0, y: -toolbar.intrinsicContentSize.height)
            $0.dataSource = self
            $0.delegate = self
        }
        view.addSubview(conversationInputView)
        keyboardObserver.addObserver(self)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        layoutInputView()
    }

    private func layoutInputView() {
        let inputSize = conversationInputView.sizeThatFits(
            CGSize(width: view.bounds.width - 2 * Dimens.marginMedium,
                   height: CGFloat.greatestFiniteMagnitude)
        )
        conversationInputView.putBottom(
            left: Dimens.marginMedium,
            bottom: keyboardObserver.keyboardInset + view.safeAreaInsets.bottom,
            right: Dimens.marginMedium,
            height: inputSize.height
        )
        conversationInputView.layoutSubviews()
    }

    func keyboardWillAnimate() {
        layoutInputView()
    }

    func keyboardDidAnimate(_ finished: Bool) {

    }
}

extension ConversationInputDemoViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let cell = cell as? ConversationCell {
            cell.bind(items[indexPath.row])
        }
        return cell
    }
}
