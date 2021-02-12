import UIKit
import oneHookLibrary

class ConversationInputDemoViewController: BaseDemoViewController, KeyboardObservable {

    private var items: [ConversationItemUIModel] = (0..<Int.random(in: 3..<20)).map { (_) in
        .fake
    }

    let tableView = EDTableView().apply {
        $0.layoutGravity = [.fill]
        $0.register(ConversationCell.self, forCellReuseIdentifier: "Cell")
        $0.keyboardDismissMode = .onDrag
        $0.layer.transform = CATransform3DMakeScale(-1, -1, 1)
        $0.separatorStyle = .none
    }

    private lazy var conversationInputView = MyConversationInputView().apply {
        $0.requiresHeight = { [weak self] (height) in
            UIView.animate(withDuration: .defaultAnimationSmall, animations: {
                guard let self = self else {
                    return
                }
                self.layoutInputView()
                self.tableView.setContentOffset(self.tableView.topOffset, animated: false)
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
        let bottomMargin = keyboardObserver.keyboardIsVisible ? Dimens.marginMedium : view.safeAreaInsets.bottom
        conversationInputView.putBottom(
            left: Dimens.marginMedium,
            bottom: keyboardObserver.keyboardInset + bottomMargin,
            right: Dimens.marginMedium,
            height: inputSize.height
        )
        conversationInputView.layoutSubviews()

        tableView.contentInset = UIEdgeInsets(
            top: keyboardObserver.keyboardInset + bottomMargin + inputSize.height + Dimens.marginMedium,
            left: 0,
            bottom: toolbar.intrinsicContentSize.height,
            right: 0
        )
    }

    func keyboardWillAnimate() {
        layoutInputView()
        tableView.setContentOffset(tableView.topOffset, animated: false)
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
