//
//  DiaryDetailViewController.swift
//  Menual
//
//  Created by 정진균 on 2022/04/16.
//

import RIBs
import RxSwift
import UIKit
import Then
import SnapKit

protocol DiaryDetailPresentableListener: AnyObject {
    // TODO: Declare properties and methods that the view controller can invoke to perform
    // business logic, such as signIn(). This protocol is implemented by the corresponding
    // interactor class.
    func pressedBackBtn()
}

final class DiaryDetailViewController: UIViewController, DiaryDetailPresentable, DiaryDetailViewControllable {

    weak var listener: DiaryDetailPresentableListener?
    
    lazy var leftBarButtonItem = UIBarButtonItem().then {
        $0.image = Asset._24px.Arrow.back.image
        $0.style = .done
        $0.target = self
        $0.action = #selector(pressedBackBtn)
    }
    
    lazy var scrollView = UIScrollView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = Colors.background.black
    }
    
    let titleLabel = UILabel().then {
        $0.font = UIFont.AppTitle(.title_5)
        $0.textColor = Colors.tint.main.v200
        $0.text = "텍스트입ㄴ다"
    }
    
    let createdAtLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.AppBodyOnlyFont(.body_3)
        $0.textColor = .white
        $0.text = "안녕하세요 만든 날짜입니다"
    }
    
    let testLabel = UILabel().then {
        $0.font = UIFont.AppTitle(.title_3)
        $0.textColor = Colors.tint.main.v200
        $0.text = "텍스트입ㄴ다"
    }
    
    lazy var descriptionTextLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.AppBodyOnlyFont(.body_3)
        $0.textColor = .white
        $0.text = "오늘의 메뉴얼을 입력해주세요.\n날짜가 적힌 곳을 탭하여 제목을 입력할 수 있습니다."
        $0.backgroundColor = .red
        $0.numberOfLines = 0
    }
    
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.layer.masksToBounds = true
    }
    
    let readCountLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = UIFont.AppBodyOnlyFont(.body_3)
        $0.textColor = .white
        $0.backgroundColor = .gray
        $0.numberOfLines = 1
        $0.textAlignment = .right
        $0.text = "0번 읽었슴다"
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
        view.backgroundColor = .gray
        setViews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        listener?.pressedBackBtn()
    }
    
    func setViews() {
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
        navigationItem.leftBarButtonItem = leftBarButtonItem
        
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(titleLabel)
        self.scrollView.addSubview(testLabel)
        self.scrollView.addSubview(descriptionTextLabel)
        self.scrollView.addSubview(imageView)
        self.scrollView.addSubview(readCountLabel)
        self.scrollView.addSubview(createdAtLabel)
        
        scrollView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.width.equalToSuperview().inset(20)
            make.top.equalToSuperview().offset(20)
        }
        
        createdAtLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }
        
        testLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.width.equalToSuperview().inset(20)
            make.top.equalTo(createdAtLabel.snp.bottom).offset(15)
        }
        
        descriptionTextLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.width.equalToSuperview().inset(20)
            make.top.equalTo(testLabel.snp.bottom).offset(40)
        }

        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.width.equalToSuperview().inset(20)
            make.top.equalTo(descriptionTextLabel.snp.bottom).offset(20)
            make.height.equalTo(200)
        }
        
        readCountLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.width.equalToSuperview().inset(20)
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.height.equalTo(20)
        }
    }
    
    func loadDiaryDetail(model: DiaryModel) {
        print("viewcontroller : \(model)")
        self.titleLabel.text = model.title
        self.testLabel.text = "\(model.weather), \(model.location)"
        self.descriptionTextLabel.text = model.description
        self.descriptionTextLabel.setLineHeight()
        self.readCountLabel.text = "\(model.readCount)번 읽었습니다"
        self.createdAtLabel.text = model.createdAt.description
        descriptionTextLabel.sizeToFit()
        createdAtLabel.sizeToFit()
    }
    
    func testLoadDiaryImage(imageName: UIImage?) {
        if let imageName = imageName {
            DispatchQueue.main.async {
                self.imageView.image = imageName
            }
        }
    }
    
    @objc
    func pressedBackBtn() {
        print("pressedBackBtn!")
        listener?.pressedBackBtn()
    }
}