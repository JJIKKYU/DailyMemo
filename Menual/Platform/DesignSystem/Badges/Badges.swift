//
//  Badges.swift
//  Menual
//
//  Created by 정진균 on 2022/10/16.
//

import UIKit
import SnapKit
import Then

// 외부에서 Bages를 사용할 때 쓰이는 Delegate
protocol BadgesDelegate {
    func show(digit: String?, type: Badges.type)
    func hide()
}

class Badges: UIView {
    
    enum type {
        case _1digit
        case _2digit
        case dot
    }
    
    var delegate: BadgesDelegate?
    
    public var badgeType: Badges.type = .dot {
        didSet { setNeedsLayout() }
    }
    
    public var digit: String = "+9" {
        didSet { setNeedsLayout() }
    }
    
    private let digitLabel = UILabel().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = Colors.grey.g800
        $0.text = "+9"
        $0.font = UIFont.AppTitle(.title_6).withSize(8)
    }

    init() {
        super.init(frame: CGRect.zero)
        setViews()
        self.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViews() {
        layer.cornerRadius = 2
        backgroundColor = Colors.tint.sub.n400
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switch badgeType {
        case .dot:
            digitLabel.text = ""
            break

        case ._1digit:
            digitLabel.text = digit
            layer.borderColor = Colors.background.cgColor
            layer.borderWidth = 1.6

        case ._2digit:
            digitLabel.text = digit
            layer.borderColor = Colors.background.cgColor
            layer.borderWidth = 1.6

        }
    }
    
    public func show() {
        self.isHidden = false
    }
    
    public func hide() {
        self.isHidden = true
    }
}