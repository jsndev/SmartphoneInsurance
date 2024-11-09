//
//  IconTextCardView.swift
//  Smartphone
//
//  Created by Dennis Torres on 03/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

import DesignSystem
import UIKit

class IconTextCardView: UIView {
    
    // MARK: - Enum
    
    private enum Constants {
        static let labelsColor: UIColor = .white
        static let leftIconSize: CGFloat = 48.0
        static let defaultSpacing: CGFloat = .spacing(.small)
        static let labelsSpacing: CGFloat = .spacing(.nano)
        static let shimmerText: String = "Lorem ipsum dolor sit"
        static let defaultIconCode = "ebb1"
        static let descShimmerRange = 12
        static let shimmerDescriptionLabelWidth: CGFloat = 178
    }
    
    // MARK: - Subviews
    
    private lazy var leftIcon: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.setIconFont(size: Constants.leftIconSize)
        label.text = iconValue.codeToIcon
        label.textColor = Constants.labelsColor
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = .zero
        label.font = .body1(.bold)
        label.text = titleText
        label.textColor = Constants.labelsColor
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = .zero
        label.font = .body2()
        label.text = descriptionText
        label.textColor = Constants.labelsColor
        return label
    }()
    
    // MARK: - Internal properties
    
    var iconValue: Icons
    var titleText: String
    var descriptionText: String
    
    // MARK: - Init
    
    init(iconCode: String, titleText: String, descriptionText: String) {
        self.iconValue = Icons(rawValue: iconCode) ?? .portoicPortoseguro
        self.titleText = titleText
        self.descriptionText = descriptionText
        super.init(frame: .zero)
        setupHierarchy()
        setupConstraints()
    }
    
    convenience init() {
        self.init(iconCode: Constants.defaultIconCode, titleText: Constants.shimmerText, descriptionText: Constants.shimmerText)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

extension IconTextCardView {
    private func setupHierarchy() {
        addSubview(leftIcon)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        leftIcon.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.size.equalTo(Constants.leftIconSize)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(leftIcon.snp.trailing).offset(Constants.defaultSpacing)
            make.top.trailing.equalToSuperview()
        }
        
        setupDescriptionConstraints()
    }
    
    private func setupDescriptionConstraints(isShimmering: Bool = false) {
        descriptionLabel.snp.removeConstraints()
        descriptionLabel.snp.makeConstraints { make in
            isShimmering
            ? make.width.equalTo(Constants.shimmerDescriptionLabelWidth).priority(.required)
            : make.trailing.equalTo(titleLabel.snp.trailing)
            
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(Constants.labelsSpacing)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Shimmer

extension IconTextCardView {
    func startShimmerCard() {
        setupDescriptionConstraints(isShimmering: true)
        
        leftIcon.text = Icons(rawValue: Constants.defaultIconCode)?.codeToIcon
        titleLabel.text = Constants.shimmerText
        descriptionLabel.text = String(Constants.shimmerText.prefix(Constants.descShimmerRange))
        
        leftIcon.shimmer.startShimmer()
        titleLabel.shimmer.startShimmer()
        descriptionLabel.shimmer.startShimmer()
    }
    
    func stopShimmerCard() {
        leftIcon.text = iconValue.codeToIcon
        titleLabel.text = titleText
        descriptionLabel.text = descriptionText
        
        leftIcon.shimmer.stopShimmer()
        titleLabel.shimmer.stopShimmer()
        descriptionLabel.shimmer.stopShimmer()
        
        setupDescriptionConstraints()
    }
}
