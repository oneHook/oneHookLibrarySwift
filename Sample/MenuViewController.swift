import UIKit
import oneHookLibrary

private struct MenuItemUIModel {
    var name: String
    var makeController: () -> (UIViewController)
}

private struct MenuSectionUIModel {
    var name: String
    var items: [MenuItemUIModel]
}

class MenuViewController: UIViewController {

    let toolbar = ViewGenerator.toolbar().apply {
        $0.layoutGravity = [.top, .fillHorizontal]
        $0.centerLabel.getOrMake().text = "Sample"
        $0.backgroundColor = UIColor(hex: "F2F2F2")
    }

    let menuTableView = EDTableView().apply {
        $0.layoutGravity = [.fill]
        $0.backgroundColor = .white
        $0.register(SimpleTableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    private var uiModels = [MenuSectionUIModel]()

    override func loadView() {
        view = FrameLayout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        view.addSubview(menuTableView)
        view.addSubview(toolbar)

        uiModels.append(MenuSectionUIModel(name: "Layout", items: [
            MenuItemUIModel(name: "Linear Layout", makeController: {
                LinearLayoutDemoViewController()
            })
        ]))

        menuTableView.dataSource = self
        menuTableView.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        menuTableView.contentInset = UIEdgeInsets(top: toolbar.bounds.height, left: 0, bottom: 0, right: 0)
    }
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        uiModels.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        uiModels[section].name
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        uiModels[section].items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let item = uiModels[indexPath.section].items[indexPath.row]
        if let cell = cell as? SimpleTableViewCell {
            cell.titleLabel.text = item.name
            cell.subtitleLabel.isHidden = true
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = uiModels[indexPath.section].items[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)

        let controller = item.makeController()
        navigationController?.pushViewController(controller, animated: true)
    }
}

