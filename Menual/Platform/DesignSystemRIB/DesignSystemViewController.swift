//
//  DesignSystemViewController.swift
//  Menual
//
//  Created by 정진균 on 2022/05/21.
//

import RIBs
import RxSwift
import SnapKit
import UIKit

protocol DesignSystemPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func pressedBackBtn()
    var designSystemVariation: [String] { get }
    
    func pressedBoxButtonCell()
}

final class DesignSystemViewController: UIViewController, DesignSystemPresentable, DesignSystemViewControllable {
    weak var listener: DesignSystemPresentableListener?
    
    lazy var naviView = MenualNaviView(type: .moments).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backButton.addTarget(self, action: #selector(pressedBackBtn), for: .touchUpInside)
        $0.backButton.setImage(Asset._24px.Arrow.back.image.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.titleLabel.text = "Design System"
    }
    
    lazy var tableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.register(DesignSystemCell.self, forCellReuseIdentifier: "DesignSystemCell")
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .white
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .fullScreen
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViews()
        print("이거 됨? \(listener?.designSystemVariation)")
    }
    
    func setViews() {
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        self.view.addSubview(naviView)
        self.view.addSubview(tableView)
        self.view.bringSubviewToFront(naviView)
        
        naviView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.centerWithinMargins.equalToSuperview()
            make.height.equalTo(44 + UIApplication.topSafeAreaHeight)
        }
        
        tableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalToSuperview().offset(44 + UIApplication.topSafeAreaHeight)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc
    func pressedBackBtn() {
        listener?.pressedBackBtn()
    }
}

// MARK: - TableView
extension DesignSystemViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "DesignSystemCell") as? DesignSystemCell else { return UITableViewCell() }
        
        guard let data = listener?.designSystemVariation else { return UITableViewCell() }
        cell.title = data[safe: indexPath.row] ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let data = listener?.designSystemVariation else { return }
        let selectedData = data[safe: indexPath.row] ?? ""
        print("selectedData = \(selectedData)")
        
        switch selectedData {
        case "GNB Header":
            break
        case "Badges":
            break
        case "Capsule Button":
            break
        case "Box Button":
            listener?.pressedBoxButtonCell()
            break
        case "Tabs":
            break
        case "FAB":
            break
        case "List Header":
            break
        case "Pagination":
            break
        case "Divider":
            break
        case "Moments":
            break
        case "List":
            break
        default:
            break
        }
    }
}