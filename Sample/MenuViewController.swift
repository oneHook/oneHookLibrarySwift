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
        $0.centerLabel.getOrMake().text = "oneHook Samples"
        $0.centerLabel.getOrMake().textColor = .defaultTextColor
        $0.backgroundColor = .defaultToolbarBackground
    }

    let menuTableView = EDTableView().apply {
        $0.layoutGravity = [.fill]
        $0.backgroundColor = .defaultBackgroundColor
        $0.register(SimpleTableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    private var uiModels = [MenuSectionUIModel]()

    override func loadView() {
        view = FrameLayout()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .defaultBackgroundColor
        view.addSubview(menuTableView)
        view.addSubview(toolbar)

        uiModels.append(MenuSectionUIModel(name: "Layout", items: [
            MenuItemUIModel(name: "LinearLayout", makeController: {
                LinearLayoutDemoViewController()
            }),
            MenuItemUIModel(name: "FrameLayout", makeController: {
                FrameLayoutLayoutDemoViewController()
            }),
            MenuItemUIModel(name: "StackLayout", makeController: {
                StackLayoutDemoViewController()
            }),
            MenuItemUIModel(name: "GridLayout", makeController: {
                GridLayoutDemoViewController()
            }),
            MenuItemUIModel(name: "FlowLayout", makeController: {
                FlowLayoutDemoViewController()
            }),
            MenuItemUIModel(name: "EqualWeightLayout", makeController: {
                EqualWeightLayoutDemoViewController()
            }),
            MenuItemUIModel(name: "RowLayout", makeController: {
                RowLayoutDemoViewController()
            })
        ]))

        uiModels.append(MenuSectionUIModel(name: "Widget", items: [
            MenuItemUIModel(name: "Controller Host", makeController: {
                ControllerHostDemoViewController()
            }),
            MenuItemUIModel(name: "Toolbar", makeController: {
                ToolbarDemoViewController()
            })
        ]))

        uiModels.append(MenuSectionUIModel(name: "Views", items: [
            MenuItemUIModel(name: "Misc Views", makeController: {
                MiscViewDemoViewController()
            }),
            MenuItemUIModel(name: "EGTextField", makeController: {
                EGTextFieldDemoViewController()
            }),
            MenuItemUIModel(name: "Digit Input View", makeController: {
                DigitInputViewDemoViewController()
            }),
            MenuItemUIModel(name: "Tab bar layout view", makeController: {
                TabbarDemoViewController()
            }),
            MenuItemUIModel(name: "Infinite Scroll View", makeController: {
                InfiniteScrollViewDemoViewController()
            }),
            MenuItemUIModel(name: "Time Picker View (WIP)", makeController: {
                TimePickerViewDemoViewController()
            }),
            MenuItemUIModel(name: "OdometerLabel", makeController: {
                OdometerDemoViewController()
            }),
            MenuItemUIModel(name: "DateWidget", makeController: {
                DateWidgetDemoViewController()
            }),
            MenuItemUIModel(name: "BarGraph", makeController: {
                BarGraphDemoViewController()
            }),
            MenuItemUIModel(name: "LineGraph", makeController: {
                LineGraphDemoViewController()
            }),
            MenuItemUIModel(name: "ProgressBar", makeController: {
                ProgressBarDemoViewController()
            }),
            MenuItemUIModel(name: "Stagger Grid", makeController: {
                StaggerGridLayoutDemoViewController()
            }),
            MenuItemUIModel(name: "Color Picker", makeController: {
                ColorPickerViewDemoViewController()
            }),
            MenuItemUIModel(name: "View Pager", makeController: {
                ViewPagerDemoViewController()
            })
        ]))

        menuTableView.dataSource = self
        menuTableView.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        menuTableView.contentInset = UIEdgeInsets(
            top: toolbar.bounds.height,
            left: 0,
            bottom: view.safeAreaInsets.bottom,
            right: 0
        )
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

//                let controller = EGTextFieldDemoViewController()
//                navigationController?.pushViewController(controller, animated: true)
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

