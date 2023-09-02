//
//  UploadImageCell.swift
//
//
//  Created by 정진균 on 2023/09/02.
//

import UIKit
import Then
import SnapKit

public protocol ImageUploadCellDelegate: AnyObject {
    func pressedTakeImageButton()
    func pressedUploadImageButton()
}

public final class ImageUploadCell: UICollectionViewCell {
    public enum Status {
        case addImage
        case image
    }

    public struct Parameters {
        public var status: Status = .addImage
        public var imageData: Data? = nil
        public var isThumb: Bool = false
    }

    public var parameters: ImageUploadCell.Parameters = .init() {
        didSet { setNeedsLayout() }
    }

    public weak var delegate: ImageUploadCellDelegate?

    private let imageView: UIImageView = .init()
    private let deleteBtn: UIButton = .init()

    // 이미지 추가하기 버튼일 경우 사용하는 View
    private let addImageStackView: UIStackView = .init()
    private let addImageView: UIImageView = .init()
    private let addImageLabel: UILabel = .init()
    private lazy var addImagePullDownButton = UIButton(frame: .zero)

    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.isUserInteractionEnabled = true
        configureUI()
        setViews()
        setImageButtonUIActionMenu()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override public func awakeFromNib() {
        super.awakeFromNib()
    }

    private func configureUI() {
        layer.cornerRadius = 8
        layer.masksToBounds = true
        backgroundColor = .clear

        imageView.do {
            $0.contentMode = .scaleAspectFill
            $0.backgroundColor = .cyan
            $0.isUserInteractionEnabled = false
        }

        deleteBtn.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }

        addImageStackView.do {
            $0.axis = .vertical
            $0.spacing = 4
            $0.distribution = .fill
            $0.alignment = .fill
            $0.isUserInteractionEnabled = false
        }

        addImageView.do {
            $0.contentMode = .scaleAspectFit
            $0.image = Asset._24px.picture.image.withRenderingMode(.alwaysTemplate)
            $0.tintColor = Colors.grey.g600
            $0.isUserInteractionEnabled = false
        }

        addImageLabel.do {
            $0.textColor = Colors.grey.g600
            $0.font = .AppBodyOnlyFont(.body_2)
            $0.text = MenualString.uploadimage_title_add
            $0.isUserInteractionEnabled = false
        }

        addImagePullDownButton.do {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .clear
            $0.showsMenuAsPrimaryAction = true
        }
    }

    private func setViews() {
        addSubview(imageView)
        addSubview(addImagePullDownButton)
        addSubview(addImageStackView)
        addImageStackView.addArrangedSubview(addImageView)
        addImageStackView.addArrangedSubview(addImageLabel)

        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        addImageStackView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }

        addImagePullDownButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()

        if let imageData: Data = parameters.imageData {
            imageView.image = UIImage(data: imageData)
        }

        if parameters.isThumb {
            print("UploadImageCell :: thumb입니다!")
        }

        switch parameters.status {
        case .addImage:
            imageView.isHidden = true
            backgroundColor = Colors.grey.g800
            addImageStackView.isHidden = false
            addImagePullDownButton.isUserInteractionEnabled = true
            break

        case .image:
            imageView.isHidden = false
            addImageStackView.isHidden = true
            addImagePullDownButton.isUserInteractionEnabled = false
            break
        }
    }
}

// MARK: - PullDownImageButton

extension ImageUploadCell {
    func setImageButtonUIActionMenu() {
        let uploadImage = UIAction(
            title: MenualString.writing_button_select_picture,
            image: Asset._24px.album.image.withRenderingMode(.alwaysTemplate))
        { [weak self] action in
            guard let self = self else { return }
            print("ImageUpload :: action! = \(action)")
            self.delegate?.pressedUploadImageButton()
        }

        let takeImage = UIAction(
            title: MenualString.writing_button_take_picture,
            image: Asset._24px.camera.image.withRenderingMode(.alwaysTemplate))
        { [weak self] action in
            guard let self = self else { return }
            print("ImageUpload :: action! = \(action)")
            self.delegate?.pressedTakeImageButton()
        }

        addImagePullDownButton.menu = UIMenu(children: [takeImage, uploadImage])
    }
}
