//
//  PlansBottomSheetView.swift
//  Smartphone
//
//  Created by Jefferson Fernandes on 07/11/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

import DesignSystem
import Core
import Combine

class PlansBottomSheetView: UIView {
    
    // MARK: - Layout Constants
    private enum Layout {
        enum Spacing {
            static let contentStackViewSpacing: CGFloat = 18
            static let buttonVerticalSpacing: CGFloat = 8
            static let contentToButtonsOffset: CGFloat = -20
        }
        
        enum FontSize {
            static let descriptionTextSize: CGFloat = FontSizeDS.body2.rawValue
        }
    }
    
    // MARK: - Strings
    private enum Strings {
        static let titleLabelText = "Contratar para outro aparelho?"
        static let descriptionLabelText = "Vamos te direcionar para o [b]site da Porto[/b] onde você poderá realizar a contratação para outro aparelho."
        static let reminderLabelText = "[b]Lembre-se:[/b] O aparelho a ser segurado deve ter até 2 anos de uso."
        static let continueButtonTitle = "Continuar para este aparelho"
        static let otherDeviceButtonTitle = "Contratar para outro aparelho"
    }
    
    // MARK: - Callbacks
    var continueButtonTapAction: (() -> Void)?
    var otherDeviceButtonTapAction: (() -> Void)?
    
    // MARK: - Views
    private lazy var titleLabel: UILabel = {
        UILabel.makeLabel(
            font: .title6(.bold),
            numberOfLines: 1
        ).apply {
            $0.text = Strings.titleLabelText
            $0.textAlignment = .left
        }
    }()
    
    private lazy var descriptionLabel: UILabel = {
        UILabel.makeLabel(
            font: .body2(.regular),
            numberOfLines: 0
        ).apply {
            $0.attributedText = .getTextUsingBBCode(
                fullText: Strings.descriptionLabelText,
                textSize: Layout.FontSize.descriptionTextSize
            )
            $0.textAlignment = .left
        }
    }()
    
    private lazy var reminderLabel: UILabel = {
        UILabel.makeLabel(
            font: .body2(.regular),
            numberOfLines: 0
        ).apply {
            $0.attributedText = .getTextUsingBBCode(
                fullText: Strings.reminderLabelText,
                textSize: Layout.FontSize.descriptionTextSize
            )
            $0.textAlignment = .left
        }
    }()
    
    private lazy var continueButton: PortoButton = {
        let button = PortoButton.instantiate(viewModel: PortoButtonViewModel(
            accessibleTitle: Strings.continueButtonTitle,
            type: .primary,
            style: .tall)) { [weak self] _ in
                guard let self = self else { return }
                self.continueButtonPressed()
            }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var otherDeviceButton: PortoButton = {
        let button = PortoButton.instantiate(viewModel: PortoButtonViewModel(
            accessibleTitle: Strings.otherDeviceButtonTitle,
            type: .ghost,
            style: .tall)) { [weak self] _ in
                guard let self = self else { return }
                self.otherDeviceButtonPressed()
            }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Stack Views
    private lazy var contentStackView: UIStackView = {
        UIStackView.makeStackView(
            axis: .vertical,
            spacing: Layout.Spacing.contentStackViewSpacing
        ).apply {
            $0.addArrangedSubview(titleLabel)
            $0.addArrangedSubview(descriptionLabel)
            $0.addArrangedSubview(reminderLabel)
            $0.alignment = .fill
            $0.distribution = .fill
        }
    }()
    
    private lazy var buttonsContainerView: UIView = {
        let view = UIView()
        view.addSubview(continueButton)
        view.addSubview(otherDeviceButton)
        return view
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods

extension PlansBottomSheetView {
    
    // MARK: - Setup Methods
    
    private func setupView() {
        backgroundColor = .white
        addSubview(contentStackView)
        addSubview(buttonsContainerView)
    }
    
    private func setupConstraints() {
        
        contentStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.bottom.lessThanOrEqualTo(buttonsContainerView.snp.top).offset(Layout.Spacing.contentToButtonsOffset)
        }
        
        buttonsContainerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        
        continueButton.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        
        otherDeviceButton.snp.makeConstraints {
            $0.top.equalTo(continueButton.snp.bottom).offset(Layout.Spacing.buttonVerticalSpacing)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func continueButtonPressed() {
        continueButtonTapAction?()
    }

    private func otherDeviceButtonPressed() {
        otherDeviceButtonTapAction?()
    }
}
