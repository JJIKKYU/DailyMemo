//
//  ListTitleView.swift
//  Menual
//
//  Created by 정진균 on 2022/11/05.
//

import UIKit
import SnapKit
import Then
import SkeletonView

public class ListTitleView: UIView {
    
    public enum ListTitleType {
        case title
        case titlePicture
        case titleHide
        case titleBodyText
    }
    
    public var listTitleType: ListTitleType = .title {
        didSet { setNeedsLayout() }
    }
    
    public var titleText: String = "타이틀 노출영역입니다." {
        didSet { setNeedsLayout() }
    }
    
    public var bodyText: String = "내용 노출 영역입니다. 최대 1줄 초과 시 말 줄임표를 사용합니다." {
        didSet { setNeedsLayout() }
    }
    
    public var searchKeyword: String = "" {
        didSet { setNeedsLayout() }
    }
    
    public let titleLabel = UILabel().then {
        $0.isSkeletonable = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "타이틀 노출영역입니다."
        $0.textColor = Colors.grey.g200
        $0.font = UIFont.AppTitle(.title_2)
        $0.numberOfLines = 1
        $0.isHidden = true
    }
    
    private let titleLeftImageView = UIImageView().then {
        $0.isSkeletonable = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.image = Asset._24px.picture.image.withRenderingMode(.alwaysTemplate)
        $0.tintColor = Colors.grey.g200
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    public let bodyLabel = UILabel().then {
        $0.isSkeletonable = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = Colors.grey.g400
        $0.font = UIFont.AppBodyOnlyFont(.body_3)
        $0.text = "내용 노출 영역입니다. 최대 1줄 초과 시 말 줄임표를 사용합니다."
        $0.numberOfLines = 1
        $0.isHidden = true
    }

    public init(type: ListTitleType) {
        self.listTitleType = type
        super.init(frame: CGRect.zero)
        setViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViews() {
        addSubview(titleLabel)
        addSubview(titleLeftImageView)
        addSubview(bodyLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.width.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        titleLeftImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        bodyLabel.snp.makeConstraints { make in
            make.leading.width.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.text = titleText
        bodyLabel.text = bodyText
        
        switch listTitleType {
        case .title:
            titleLabel.textColor = Colors.grey.g200
            titleLabel.isHidden = false
            
            titleLeftImageView.isHidden = true
            
            titleLabel.snp.remakeConstraints { make in
                make.leading.width.equalToSuperview()
                make.centerY.equalToSuperview()
            }
            
        case .titlePicture:
            titleLabel.textColor = Colors.grey.g200
            titleLabel.isHidden = false
            titleLeftImageView.isHidden = false
            
            titleLabel.snp.remakeConstraints { make in
                make.leading.equalTo(titleLeftImageView.snp.trailing).offset(2)
                make.width.equalToSuperview()
                make.centerY.equalToSuperview()
            }
            
        case .titleHide:
            titleLabel.isHidden = false
            titleLeftImageView.isHidden = false
            titleLabel.textColor = Colors.grey.g600
            titleLeftImageView.tintColor = Colors.grey.g600
            titleLeftImageView.image = Asset._24px.lock.image.withRenderingMode(.alwaysTemplate)
            
            titleLabel.snp.remakeConstraints { make in
                make.leading.equalTo(titleLeftImageView.snp.trailing).offset(2)
                make.width.equalToSuperview()
                make.centerY.equalToSuperview()
            }
            
        case .titleBodyText:
            titleLeftImageView.isHidden = true
            
            titleLabel.textColor = Colors.grey.g200
            bodyLabel.textColor = Colors.grey.g400
            bodyLabel.isHidden = false
            
        }
        
        highlightText(keyword: searchKeyword)
    }

    
    public func highlightText(keyword: String) {
        // 타이틀
        switch listTitleType {
        case .titlePicture, .title:
            let titleAtrString = NSMutableAttributedString(string: titleText)
            titleAtrString.addAttribute(.foregroundColor, value: Colors.tint.main.v400, range: (titleText as NSString).range(of: keyword))
            
            titleLabel.attributedText = titleAtrString
        case .titleBodyText:
            let bodyAtrString = NSMutableAttributedString(string: bodyText)
            bodyAtrString.addAttribute(.foregroundColor, value: Colors.tint.main.v400, range: (bodyText as NSString).range(of: keyword))
            
            bodyLabel.attributedText = bodyAtrString
        default:
            break
        }
        
        
        // TODO: - 내용도 하이라이트 될 수 있도록 추가할 것
        /*
        let descAtrString = NSMutableAttributedString(string: desc)
        descAtrString.addAttribute(.foregroundColor, value: UIColor.blue, range: (desc as NSString).range(of: text))
        descriptionLabel.attributedText = descAtrString
        */
    }
    
}
