//
//  DiarySearchViewController.swift
//  Menual
//
//  Created by 정진균 on 2022/03/27.
//

import RIBs
import RxSwift
import Then
import SnapKit
import UIKit
import RxRelay

protocol DiarySearchPresentableListener: AnyObject {
    var recentSearchResultList: [SearchModel] { get }
    var searchResultsRelay: BehaviorRelay<[DiaryModel]> { get }
    
    func pressedBackBtn(isOnlyDetach: Bool)
    func searchTest(keyword: String)
    func searchDataTest(keyword: String)
    func fetchRecentSearchList()
    func pressedSearchCell(diaryModel: DiaryModel)
}

final class DiarySearchViewController: UIViewController, DiarySearchPresentable, DiarySearchViewControllable {

    weak var listener: DiarySearchPresentableListener?
    var disposeBag = DisposeBag()
    
    lazy var naviView = MenualNaviView(type: .moments).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backButton.addTarget(self, action: #selector(pressedBackBtn), for: .touchUpInside)
        $0.titleLabel.text = MenualString.title_search
    }
    
    var recentSearchListView = UIView().then {
        $0.backgroundColor = Colors.background
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    lazy var searchBtn = UIButton().then {
        $0.setImage(Asset._24px.search.image.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.addTarget(self, action: #selector(pressedSearchBtn), for: .touchUpInside)
        $0.contentMode = .scaleAspectFit
        $0.contentHorizontalAlignment = .fill
        $0.contentVerticalAlignment = .fill
    }
    
    lazy var recentSearchTableView = UITableView().then {
        $0.isHidden = false
        $0.delegate = self
        $0.dataSource = self
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = Colors.background
        $0.register(RecentSearchCell.self, forCellReuseIdentifier: "RecentSearchCell")
    }
    
    lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.dataSource = self
        
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = Colors.background
        $0.register(ListCell.self, forCellReuseIdentifier: "ListCell")
        $0.estimatedRowHeight = 87
        $0.rowHeight = 87
        $0.isHidden = true
        $0.estimatedRowHeight = 72
        $0.rowHeight = 72
        $0.showsVerticalScrollIndicator = false
    }
    
    lazy var searchTextField = UITextField().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
        $0.backgroundColor = Colors.background
    }
    
    private let searchMenualCountLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.AppHead(.head_4)
        $0.textColor = .white
        $0.text = "총 N개의 메뉴얼"
    }
    
    var searchView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .red
        $0.frame = CGRect(x: 0, y: 0, width: 200, height: 80)
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
        view.backgroundColor = .black
        print("DiarySearch!!")
        setViews()
        bind()
        // 뒤로가기 제스쳐 가능하도록
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchTextField.becomeFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isMovingFromParent || isBeingDismissed {
            listener?.pressedBackBtn(isOnlyDetach: true)
        }
    }
    
    func bind() {
        searchTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] keyword in
                guard let self = self else { return }
                
                 // self.listener?.searchDataTest(keyword: keyword)
                 self.listener?.searchTest(keyword: keyword)
//                self.listener?.fetchRecentSearchList()
                
                if keyword.count == 0 {
                    self.tableView.isHidden = true
                    self.recentSearchListView.isHidden = false
                    self.recentSearchTableView.isHidden = false
                } else {
                    self.tableView.isHidden = false
                    self.recentSearchListView.isHidden = true
                    self.recentSearchTableView.isHidden = true
                }
            })
            .disposed(by: disposeBag)
        
        listener?.searchResultsRelay
            .subscribe(onNext: { [weak self] results in
                guard let self = self else { return }
                
                if results.count == 0 {
                    self.searchMenualCountLabel.text = "empty페이지 띄워라"
                } else {
                    let count = results.count
                    self.searchMenualCountLabel.text = "총 \(count)개의 메뉴얼"
                }
                
                self.tableView.reloadData()
                // recentSearchTableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    func setViews() {
        
        self.view.addSubview(tableView)
        self.view.addSubview(naviView)
        self.view.addSubview(searchTextField)
        self.view.addSubview(searchBtn)
        self.view.bringSubviewToFront(naviView)
        self.view.addSubview(recentSearchTableView)
        self.tableView.addSubview(searchView)
        tableView.tableHeaderView = searchView
        searchView.addSubview(searchMenualCountLabel)
        searchView.sizeToFit()
        
        searchView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(100)
        }
        
        recentSearchTableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalTo(searchTextField.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
        }
        
        searchTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(200)
            make.top.equalToSuperview().offset(100)
            make.height.equalTo(50)
        }
        
        searchMenualCountLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(40)
            make.width.equalToSuperview().inset(20)
        }
        
        searchBtn.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(100)
            make.width.height.equalTo(24)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(30)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        naviView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.height.equalTo(44 + UIApplication.topSafeAreaHeight)
            make.top.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    
    @objc
    func pressedBackBtn() {
        print("ProfileHomeVC :: pressedBackBtn!")
        listener?.pressedBackBtn(isOnlyDetach: false)
    }
    
    @objc
    func pressedSearchBtn() {
        print("pressedSearchBtn")
        // 검색 버튼 누를때 조건 추가 할 것
        guard let text = searchTextField.text else { return }
        if text.count == 0 {
            print("검색 키워드를 입력해주세요")
            return
        }
        listener?.searchDataTest(keyword: text)
        listener?.searchTest(keyword: text)
        listener?.fetchRecentSearchList()
        
        self.tableView.isHidden = false
        self.recentSearchListView.isHidden = true
        self.recentSearchTableView.isHidden = true
    }
    
    // RecentSearchCell의 Delete Btn이 클릭되었을때
    @objc
    func pressedRecentSearchCellDeleteBtn() {
        print("pressedDeleteBtn!")
    }
    
    func reloadSearchTableView() {
        tableView.reloadData()
        recentSearchTableView.reloadData()
    }
}


extension DiarySearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // 검색 결과 TableView
        if tableView == self.tableView {
            return listener?.searchResultsRelay.value.count ?? 0
        }
        // 최근 검색 키워드 TableView
        else if tableView == self.recentSearchTableView {
            return listener?.recentSearchResultList.count ?? 0
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        // 검색 결과 TableView
        if tableView == self.tableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as? ListCell else { return UITableViewCell() }
            
            guard let model = listener?.searchResultsRelay.value[safe: index],
                  let searchKeyword = self.searchTextField.text else {
                return UITableViewCell()
            }
            
            cell.uuid = model.uuid
            if model.isHide {
                cell.listType = .hide
            } else {
                // TODO: - 이미지가 있을 경우 이미지까지
                cell.listType = .text
            }
            cell.title = model.title
            cell.dateAndTime = model.createdAt.toString()

            let page = "P.\(model.pageNum)"
            var replies = ""
            if model.replies.count != 0 {
                replies = "- \(model.replies.count)"
            }

            cell.searchKeyword = searchKeyword
            cell.pageAndReview = page + replies
            
            return cell
        }
        // 최근 검색 키워드 TableView
        else if tableView == self.recentSearchTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecentSearchCell") as? RecentSearchCell else { return UITableViewCell() }
            
            guard let model = listener?.recentSearchResultList[safe: index] else {
                return UITableViewCell()
            }
            
            cell.keyword = model.keyword
            cell.createdAt = model.createdAt.toStringWithHourMin()
            cell.deleteBtn.addTarget(self, action: #selector(pressedRecentSearchCellDeleteBtn), for: .touchUpInside)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 검색 결과 TableView
        if tableView == self.tableView {
            guard let cell = tableView.cellForRow(at: indexPath) as? ListCell else { return }
            print("선택했습니다! - \(cell.uuid)")
            
            let index = indexPath.row
            guard let model = listener?.searchResultsRelay.value[safe: index] else {
                return
            }
            
            print("이거 = \(model.uuid), \(cell.uuid)")
            
            listener?.pressedSearchCell(diaryModel: model)
        }
    }
}

extension DiarySearchViewController: UISearchBarDelegate {
    
}

extension DiarySearchViewController: UITextFieldDelegate {
    
}
