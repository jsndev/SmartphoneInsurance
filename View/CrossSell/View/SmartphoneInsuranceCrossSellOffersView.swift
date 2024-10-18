//
//  SmartphoneInsuranceCrossSellOffersView.swift
//  Smartphone
//
//  Created by MARCOS VINICIUS DOS SANTOS FERREIRA on 31/05/22.
//  Copyright © 2022 Porto Seguro. All rights reserved.
//

import Components
import DesignSystem
import SnapKit
import UIKit

protocol CrossSellOffersViewDelegate: AnyObject {
    func didClickMakeQuote(url: String)
}

class SmartphoneInsuranceCrossSellOffersView: UIView {
    
    private let iconSize: CGFloat = 40
    private let iconViewCornerRadio: CGFloat = 8
    private let containerImageCornerRadio: CGFloat = 16
    weak var delegate: CrossSellOffersViewDelegate?
    
    private let shadowColor: CGColor = UIColor.black.cgColor
    private let shadowOpacity: Float = 0.25
    private let shadowRadius: CGFloat = 4.0
    private let shadowOffset = CGSize(width: .zero, height: 2)
    private let cornerRadius: CGFloat = 4.0
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .neutralColorWhite
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = cornerRadius
        view.setShadow(color: shadowColor, opacity: shadowOpacity, offset: shadowOffset, radius: shadowRadius)
        return view
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    private lazy var containerIconView: UIView = {
        let view = UIView()
        view.backgroundColor = .brandSupport04
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = iconViewCornerRadio
        
        return view
    }()
    
    private lazy var iconLabel: UILabel = {
        let label = UILabel()
        label.text = Icons.smartphone.codeToIcon
        label.textColor = .brandColorPrimary
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.setIconFont(size: .size(.medium))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = false

        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: .openSansBold, size: FontSize.large.rawValue)
        label.textColor = .neutralColorDarkest
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true

        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: .openSansRegular, size: FontSize.minimum.rawValue)
        label.textColor = .neutralColorGrey01
        label.backgroundColor = .clear
        label.numberOfLines = .zero
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true

        return label
    }()
    
    private lazy var containerImageView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        view.layer.cornerRadius = containerImageCornerRadio
        
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(assetsSmartphone: .crossSellImage)
        imageView.isAccessibilityElement = true
        imageView.accessibilityLabel = AccessibilityLocalizableBundle.crossSellImageMessage.accessibilityLocalize
        
        return imageView
    }()
    
    private lazy var containerTextsView: UIView = {
        let view = UIView()
        view.backgroundColor = .neutralColorDarkest
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()

    private lazy var promotionalTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: .openSansRegular, size: FontSize.minimum.rawValue)
        label.textColor = .neutralColorGrey03
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.numberOfLines = .zero

        return label
    }()
    
    private lazy var promotionalDescriptionLabel: UILabel = {
        let label = UILabel()
        
        label.textColor = .neutralColorGrey03
        label.backgroundColor = .clear
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isAccessibilityElement = true
        label.numberOfLines = .zero

        return label
    }()
    
    private lazy var makeQuoteButton: PrimaryButton = {
        let primaryButton = PrimaryButton()
        primaryButton.isAccessibilityElement = true
        primaryButton.accessibilityTraits = .button
        primaryButton.accessibilityLabel = AccessibilityLocalizableBundle.makeQuoteButton.accessibilityLocalize
        
        return primaryButton
    }()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func  didMoveToWindow() {
        setupConstraints()
        setupView()
    }
    
    func setup(viewModel: SmartphoneInsuranceCrossSellOffersViewModelProtocol) {
        titleLabel.text = viewModel.headerTitle
        descriptionLabel.text = viewModel.description
        promotionalTitleLabel.text = viewModel.promotionalTitle
        promotionalDescriptionLabel.text = viewModel.promotionalDescription
        
        var makeQuoteViewModel = PrimaryButtonViewModel(title: viewModel.buttonTitle, type: .primary, isEnabled: true)
        makeQuoteViewModel.setupAction { [weak self] in
            self?.delegate?.didClickMakeQuote(url: viewModel.quoteURL)
        }
        makeQuoteButton.setup(withViewModel: makeQuoteViewModel)
    }

    private func setupView() {
        accessibilityElements = [titleLabel, descriptionLabel, imageView, promotionalTitleLabel, promotionalDescriptionLabel, makeQuoteButton]
        backgroundColor = .clear
    }
    
    private func setupConstraints() {
        setupContainerConstraints()
        setupHeaderConstraints()
        setupDescriptionLabel()
        setupImageAndTextConstraints()
        setupButtonConstraints()
    }
    
    private func setupContainerConstraints() {
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().inset(CGFloat.spacing(.medium))
            make.trailing.equalToSuperview().inset(CGFloat.spacing(.medium))
            make.bottom.equalToSuperview().inset(CGFloat.spacing(.medium))
        }
    }
    
    private func setupHeaderConstraints() {
        containerView.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(CGFloat.spacing(.medium))
            make.left.equalToSuperview().inset(CGFloat.spacing(.small))
            make.right.equalToSuperview().inset(CGFloat.spacing(.small))
            make.height.equalTo(iconSize)
        }
        
        // iconView
        headerView.addSubview(containerIconView)
        containerIconView.snp.makeConstraints { make in
            make.top.equalTo(headerView)
            make.left.equalTo(headerView)
            make.height.equalTo(iconSize)
            make.width.equalTo(iconSize)
        }
        
        // iconLabel
        containerIconView.addSubview(iconLabel)
        iconLabel.snp.makeConstraints { make in
            make.top.equalTo(containerIconView)
            make.left.equalTo(containerIconView)
            make.right.equalTo(containerIconView)
            make.bottom.equalTo(containerIconView)
        }
        
        // header title
        headerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(containerIconView.snp.right).offset(CGFloat.spacing(.extraSmall))
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    private func setupDescriptionLabel() {
        containerView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom).offset(CGFloat.spacing(.medium))
            make.left.equalTo(containerView).inset(CGFloat.spacing(.small))
            make.right.equalTo(containerView).inset(CGFloat.spacing(.small))
        }
    }
    
    private func setupImageAndTextConstraints() {
        containerView.addSubview(containerImageView)
        containerImageView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(CGFloat.spacing(.medium))
            make.left.equalToSuperview().inset(CGFloat.spacing(.small))
            make.right.equalToSuperview().inset(CGFloat.spacing(.small))
        }
        
        // imageView        
        containerImageView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(containerImageView.snp.width)
        }
        
        // containerTextsView
        containerImageView.addSubview(containerTextsView)
        containerTextsView.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        // promotionalTitleLabel
        containerTextsView.addSubview(promotionalTitleLabel)
        promotionalTitleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(CGFloat.spacing(.small))
            make.left.equalToSuperview().inset(CGFloat.spacing(.small))
            make.right.equalToSuperview().inset(CGFloat.spacing(.small))
        }
        
        // promotionalDescriptionLabel
        containerTextsView.addSubview(promotionalDescriptionLabel)
        promotionalDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(promotionalTitleLabel.snp.bottom).offset(CGFloat.spacing(.small))
            make.left.equalToSuperview().inset(CGFloat.spacing(.small))
            make.right.equalToSuperview().inset(CGFloat.spacing(.small))
            make.bottom.equalToSuperview().inset(CGFloat.spacing(.medium))
        }
    }
    
    private func setupButtonConstraints() {
        containerView.addSubview(makeQuoteButton)
        makeQuoteButton.snp.makeConstraints { make in
            make.top.equalTo(containerImageView.snp.bottom).offset(CGFloat.spacing(.medium))
            make.left.equalTo(containerView).inset(CGFloat.spacing(.small))
            make.right.equalTo(containerView).inset(CGFloat.spacing(.small))
            make.bottom.equalTo(containerView).inset(CGFloat.spacing(.medium))
            make.height.equalTo(CGFloat.size(.large))
        }
    }
}
