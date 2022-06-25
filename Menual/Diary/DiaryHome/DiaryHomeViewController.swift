//
//  DiaryHomeViewController.swift
//  Menual
//
//  Created by 정진균 on 2022/01/22.
//

import RIBs
import RxSwift
import RxRelay
import UIKit
import SnapKit
import Then

protocol DiaryHomePresentableListener: AnyObject {
    func pressedSearchBtn()
    func pressedMyPageBtn()
    func pressedMomentsTitleBtn()
    func pressedMomentsMoreBtn()
    func pressedWritingBtn()
    
    func getMyMenualCount() -> Int
    func getMyMenualArr() -> [DiaryModel]
    
    func pressedDiaryCell(index: Int)
    
    func pressedMenualTitleBtn()
    
    var lastPageNumRelay: BehaviorRelay<Int> { get }
    var diaryMonthSetRelay: BehaviorRelay<[DiaryYearModel]> { get }
}

final class DiaryHomeViewController: UIViewController, DiaryHomePresentable, DiaryHomeViewControllable {
    
    weak var listener: DiaryHomePresentableListener?
    // 스크롤 위치 저장하는 Dictionary
    var myMenualCellIndexPathDic: [String: [String: IndexPath]]?
    var disposeBag = DisposeBag()
    
    // MARK: - UI 코드
    private let tableViewHeaderView = UIView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
    }

    lazy var naviView = MenualNaviView(type: .main).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.rightButton1.setImage(Asset._24px.profile.image.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.rightButton1.addTarget(self, action: #selector(pressedMyPageBtn), for: .touchUpInside)
        
        $0.rightButton2.setImage(Asset._24px.search.image.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.rightButton2.addTarget(self, action: #selector(pressedSearchBtn), for: .touchUpInside)
        
        // #if DEBUG
        $0.menualTitleImage.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(pressedMenualBtn))
        $0.menualTitleImage.addGestureRecognizer(gesture)
        // #endif
    }
    
    // TODO: CustomView로 만들기
    lazy var fabWriteBtn = BoxButton(frame: CGRect.zero, btnStatus: .active, btnSize: .xLarge).then {
        $0.title = "N번째 메뉴얼 작성하기"
        $0.addTarget(self, action: #selector(pressedFABWritingBtn), for: .touchUpInside)
    }
    
    lazy var momentsTitleView = ListHeader(type: .textandicon, rightIconType: .arrow).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.title = "MY MOMENTS"
        $0.rightArrowBtn.addTarget(self, action: #selector(pressedMomentsMoreBtn), for: .touchUpInside)
    }

    lazy var momentsCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout()).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        let flowlayout = CustomCollectionViewFlowLayout.init()
        flowlayout.itemSize = CGSize(width: self.view.bounds.width - 40, height: 120)
        flowlayout.scrollDirection = .horizontal
        flowlayout.minimumLineSpacing = 10
        flowlayout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.setCollectionViewLayout(flowlayout, animated: true)
        $0.delegate = self
        $0.dataSource = self
        $0.register(MomentsCell.self, forCellWithReuseIdentifier: "MomentsCell")
        $0.register(DividerView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "DividerView")
        $0.backgroundColor = .clear
        $0.decelerationRate = .fast
        $0.isPagingEnabled = false
        $0.tag = 0
        $0.showsHorizontalScrollIndicator = false
    }
    
    private let momentsCollectionViewPagination = Pagination().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.numberOfPages = 5
    }
    
    lazy var myMenualTitleView = ListHeader(type: .textandicon, rightIconType: .none).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.title = "MY MENUAL"
    }
    
    lazy var myMenualPageTitleView = ListHeader(type: .datepageandicon, rightIconType: .filter).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.title = "PAGE.999"
    }
    
    lazy var myMenualTableView = UITableView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.delegate = self
        $0.dataSource = self
        $0.backgroundColor = .clear
        $0.register(ListCell.self, forCellReuseIdentifier: "ListCell")
        $0.estimatedRowHeight = 72
        $0.rowHeight = 72
        $0.showsVerticalScrollIndicator = false
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 72, right: 0)
        $0.tag = -1
    }
    
    private let divider = Divider(type: ._2px).then {
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // MARK: - VC 코드
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
        print("DiaryHome!")
        setViews()
        bind()
    }
    
    func setViews() {
        self.view.backgroundColor = Colors.background
        
        self.view.addSubview(naviView)
        self.view.addSubview(fabWriteBtn)
        
        self.view.addSubview(myMenualTableView)
        myMenualTableView.tableHeaderView = tableViewHeaderView
        tableViewHeaderView.addSubview(momentsTitleView)
        tableViewHeaderView.addSubview(momentsCollectionView)
        tableViewHeaderView.addSubview(momentsCollectionViewPagination)
        tableViewHeaderView.addSubview(myMenualTitleView)
        tableViewHeaderView.addSubview(divider)
        tableViewHeaderView.addSubview(myMenualPageTitleView)
        
        naviView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(44 + UIApplication.topSafeAreaHeight)
        }
        
        self.view.bringSubviewToFront(naviView)
        self.view.bringSubviewToFront(fabWriteBtn)
        
        myMenualTableView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        tableViewHeaderView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(320)
        }
        self.view.layoutIfNeeded()
        
        print("UIApplication.topSafeAreaHeight = \(UIApplication.topSafeAreaHeight)")
        
        momentsTitleView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalToSuperview().offset(44 + 16)
            make.height.equalTo(24)
        }
        
        momentsCollectionView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(momentsTitleView.snp.bottom).offset(12)
            make.height.equalTo(125)
        }
        
        momentsCollectionViewPagination.snp.makeConstraints { make in
            make.top.equalTo(momentsCollectionView.snp.bottom).offset(10)
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(4)
        }
        
        myMenualTitleView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(momentsCollectionViewPagination.snp.bottom).offset(12)
            make.height.equalTo(22)
        }
        
        myMenualPageTitleView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(myMenualTitleView.snp.bottom).offset(16)
            make.height.equalTo(24)
        }
        
        divider.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.width.equalToSuperview().inset(20)
            make.top.equalTo(myMenualPageTitleView.snp.bottom).offset(8)
            make.height.equalTo(2)
        }
        
        fabWriteBtn.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(56)
            make.bottom.equalToSuperview().inset(34)
        }
    }
    
    func bind() {
        listener?.lastPageNumRelay
            .subscribe(onNext: { [weak self] num in
                guard let self = self else { return }
                print("num!! = \(num)")
                self.myMenualPageTitleView.title = "PAGE." + String(num)
                self.fabWriteBtn.title = String(num + 1) + "번째 메뉴얼 작성하기"
            })
            .disposed(by: self.disposeBag)
    }
    
    @objc
    func pressedSearchBtn() {
        listener?.pressedSearchBtn()
    }
    
    @objc
    func pressedMyPageBtn() {
        listener?.pressedMyPageBtn()
    }
    
    @objc
    func pressedMomentsTitleBtn() {
        listener?.pressedMomentsTitleBtn()
        print("Moments Title Pressed!")
    }
    
    @objc
    func pressedMomentsMoreBtn() {
        listener?.pressedMomentsMoreBtn()
        print("Moments More Pressed!")
    }
    
    @objc
    func pressedMyMenualBtn() {
        
    }
    
    @objc
    func pressedFABWritingBtn() {
        print("FABWritingBtn Pressed!")
        listener?.pressedWritingBtn()
    }
    
    @objc
    func pressedMenualBtn() {
        print("메뉴얼 버튼 눌렀니?")
        listener?.pressedMenualTitleBtn()
    }
}

// MARK: - Scroll View
extension DiaryHomeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        momentsPagination(scrollView)
    }

    func momentsPagination(_ scrollView: UIScrollView) {
        // MomentCollectionView 일때만 작동 되도록
        if scrollView.tag == 0 {
            let width = scrollView.bounds.size.width
            // Init할 때 width가 모두 그려지지 않을때 오류 발생
            if width == 0 { return }
            // 좌표보정을 위해 절반의 너비를 더해줌
            let x = scrollView.contentOffset.x + (width/2)
           
            let newPage = Int(x / width)
            if momentsCollectionViewPagination.currentPage != newPage {
                momentsCollectionViewPagination.currentPage = newPage
            }
        }
    }
}

// MARK: - UITableView Deleagte, Datasource
extension DiaryHomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return listener?.getMyMenualCount() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell") as? ListCell else { return UITableViewCell() }
        
        cell.backgroundColor = .clear
        
        guard let myMenualArr = listener?.getMyMenualArr() else { return UITableViewCell() }
        
        let data = myMenualArr[indexPath.row]
        if data.isHide {
            cell.listType = .hide
        } else {
            // TODO: - 이미지가 있을 경우 이미지까지
            cell.listType = .text
        }
        
        cell.title = data.title
        cell.dateAndTime = data.createdAt.toString()
        
        let page = "P.\(data.pageNum)"
        var replies = ""
        if data.replies.count != 0 {
            replies = "- \(data.replies.count)"
        }

        cell.pageAndReview = page + replies

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // guard let cell = tableView.cellForRow(at: indexPath) as? ListCell else { return }
        
        listener?.pressedDiaryCell(index: indexPath.row)
    }
    
    func reloadTableView() {
        print("reloadTableView!")
        myMenualTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // print("tableView ContentSize = \(self.myMenualTableView.contentSize.height)")
        
//        myMenualTableView.snp.removeConstraints()
//        myMenualTableView.snp.makeConstraints { make in
//            make.leading.equalToSuperview()
//            make.width.equalToSuperview()
//            make.bottom.equalToSuperview().inset(myMenualTableView.contentSize.height)
//            make.top.equalTo(divider.snp.bottom).offset(0)
//        }
    }
}

// MARK: - UICollectionView Delegate, Datasource
extension DiaryHomeViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        
        switch collectionView.tag {
        // MomentsCollectionView
        case 0:
            print("kind = \(kind)")
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "DividerView", for: indexPath) as! DividerView
            print("sectionHeader = \(sectionHeader)")
            return sectionHeader

        default:
            return UICollectionReusableView()
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        switch collectionView.tag {
        // MomentsCollectionView
        case 0:
            return CGSize.zero
            
        default:
            return CGSize.zero
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView.tag {
        // MomentsCollectionView
        case 0:
            return 1
            
        default:
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        // MomentsCollectionView
        case 0:
            let momentsCollectionViewCount: Int = 5
            self.momentsCollectionViewPagination.numberOfPages = momentsCollectionViewCount
            return momentsCollectionViewCount
        
        default:
            return 5
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch collectionView.tag {
        // MomentsCollectionView
        case 0:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MomentsCell", for: indexPath) as? MomentsCell else { return UICollectionViewCell() }
            
            cell.tagTitle = "TEXT AREA"
            cell.momentsTitle = "타이틀은 최대 20자를 작성할 수 있습니다. 그 이상일 경우 우오아우아"
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        switch collectionView.tag {
        // MomentsCollectionView
        case 0:
            let width = UIScreen.main.bounds.width - 40
            return CGSize(width: width, height: 125)
            
        default:
            return CGSize(width: 32, height: 32)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView.tag {
        // MomentsCollectionView
        case 0:
            print("MomentsCollectionView Selected!")
            
        default:
            return
        }
    }
}
