import UIKit
import oneHookLibrary

class ConversationInputDemoViewController: BaseDemoViewController, KeyboardObservable {

    private var items: [ConversationItemUIModel] = (0..<Int.random(in: 3..<20)).map { (_) in
        .fake
    }

    let tableView = EDTableView().apply {
        $0.layoutGravity = [.fill]
        $0.register(ConversationCell.self, forCellReuseIdentifier: "Cell")
        $0.keyboardDismissMode = .interactive
        $0.layer.transform = CATransform3DMakeScale(-1, -1, 1)
        $0.separatorStyle = .none
        $0.showsVerticalScrollIndicator = false
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
        $0.willSendByEnter = { [weak self] (text) in
            self?.sendMessage(text: text)
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
        if keyboardObserver.keyboardIsVisible {
            tableView.setContentOffset(tableView.topOffset, animated: false)
        }
    }

    func keyboardDidAnimate(_ finished: Bool) {

    }

    func sendMessage(text: String) {
        conversationInputView.clearInput()
        guard text.isNotEmpty else {
            return
        }

        let model = ConversationItemUIModel(direction: .left, text: text)
        items.insert(model, at: 0)
        tableView.performBatchUpdates {
            tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .top)
        } completion: { (_) in

        }
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
