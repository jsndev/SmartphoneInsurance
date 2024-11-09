//
//  PhoneInsuranceErrorView.swift
//  Smartphone
//
//  Created by Dennis Torres on 04/11/24.
//

import DesignSystem
import UIKit

class PhoneInsuranceErrorView: UIView {
    
    // MARK: - Enums
    
    enum ErrorType {
        case noConnection, tryAgain(Int), badRequest
    }
    
    private enum Constants {
        static let backgroundColor: UIColor = .white
        static let heightNavigation: CGFloat = 60
        static let edgeSpacing: CGFloat = 20
        static let topSpacing: CGFloat = .spacing(.large)
        static let verticalSpacing: CGFloat = .spacing(.medium)
        static let componentsSpacing: CGFloat = .spacing(.small)
        static let buttonsSpacing: CGFloat = .spacing(.extraSmall)
        static let iconSize: CGFloat = .size(.xLarger)
        static let separatorHeight: CGFloat = 1
    }
    
    // MARK: - Subviews
    
    private lazy var navigationBar: PortoNavigationView = {
        let navViewModel = PortoNavigationViewModel(
            style: .white
        )
        let navBar = PortoNavigationView.instantiate(viewModel: navViewModel) { [weak self] _ in
            self?.dismissAction?()
        }
        return navBar
    }()
    
    private lazy var iconView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.setIconFont(size: Constants.iconSize)
        label.textColor = .black
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = .zero
        label.lineBreakMode = .byWordWrapping
        label.font = .title5(.bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.numberOfLines = .zero
        label.lineBreakMode = .byWordWrapping
        label.font = .body1()
        label.textColor = .black
        return label
    }()
    
    private lazy var mainStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Constants.componentsSpacing
        return stackView
    }()
    
    private lazy var lineSeparator: UIView = {
        let line: UIView = .createEmptyView()
        line.backgroundColor = .black15
        return line
    }()
    
    private lazy var buttonsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = Constants.buttonsSpacing
        return stackView
    }()
    
    private lazy var highlightedButton: PortoButton = {
        let buttonViewModel = PortoButtonViewModel(
            vertical: .insurance,
            type: .primary,
            style: .tall
        )
        return PortoButton.instantiate(viewModel: buttonViewModel) { [weak self] _ in
            self?.buttonAction?()
        }
    }()
    
    private lazy var notNowButton: PortoButton = {
        let buttonViewModel = PortoButtonViewModel(
            accessibleTitle: LocalizableBundle.offersDenyButtonName.localize,
            vertical: .custom(
                mainColor: .white,
                highlightColor: .portoSeguros100,
                textBorderColor: .portoSeguros100
            ),
            type: .primary,
            style: .tall
        )
        return PortoButton.instantiate(viewModel: buttonViewModel) { [weak self] _ in
            self?.dismissAction?()
        }
    }()
    
    // MARK: - Internal properties
    
    var dismissAction: (() -> Void)?
    var buttonAction: (() -> Void)?
    
    var errorType: ErrorType? {
        didSet {
            hasSecondButton = false
            setup()
        }
    }
    
    // MARK: - Private properties
    
    private var hasSecondButton: Bool = false
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        dismissAction = nil
        buttonAction = nil
    }
}

// MARK: - Private methods

extension PhoneInsuranceErrorView {
    private func setup() {
        resetComponents()
        setupElements()
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupElements() {
        guard let errorType else { return }
        switch errorType {
        case .noConnection:
            iconView.text = Icons.portoicWifiAlert.codeToIcon
            titleLabel.text = LocalizableBundle.inspectionNoConnectionErrorViewTitle.localize
            descriptionLabel.text = LocalizableBundle.inspectionNoConnectionErrorViewSubTitle.localize
            highlightedButton.setTitle(LocalizableBundle.goHomeTitleContinueButton.localize, for: .normal)
        case .tryAgain(let attempts):
            iconView.text = Icons.portoicSystemError.codeToIcon
            switch attempts {
            case 0..<2:
                titleLabel.text = LocalizableBundle.inspectionNotFoundInfoErrorViewTitle.localize
                descriptionLabel.text = LocalizableBundle.smartphoneNotFoundInfoErrorViewSubTitle.localize
                highlightedButton.setTitle(LocalizableBundle.tryAgainTitleContinueButton.localize, for: .normal)
            case 2:
                titleLabel.text = LocalizableBundle.smartphoneStillNotFoundInfoErrorViewTitle.localize
                descriptionLabel.text = LocalizableBundle.inspectionSystemsOutErrorViewSubTitle.localize
                highlightedButton.setTitle(LocalizableBundle.tryAgainTitleContinueButton.localize, for: .normal)
            default:
                hasSecondButton = true
                titleLabel.text = LocalizableBundle.smartphoneUnstableSystemErrorViewTitle.localize
                descriptionLabel.text = LocalizableBundle.smartphoneUnstableSystemErrorViewSubTitle.localize
                highlightedButton.setTitle(LocalizableBundle.smartphoneDirectToWebsite.localize, for: .normal)
            }
        case .badRequest:
            hasSecondButton = true
            iconView.text = Icons.portoicSystemError.codeToIcon
            titleLabel.text = LocalizableBundle.smartphoneInstallmentsErrorMessage.localize
            descriptionLabel.text = LocalizableBundle.smartphoneBadRequestErrorViewSubTitle.localize
            highlightedButton.setTitle(LocalizableBundle.smartphoneDirectToWebsite.localize, for: .normal)
        }
        backgroundColor = Constants.backgroundColor
    }
    
    private func setupHierarchy() {
        addSubview(navigationBar)
        addSubview(buttonsStack)
        addSubview(lineSeparator)
        addSubview(mainStack)
        let spaceView = UIView()
        mainStack.addArrangedSubview(spaceView)
        mainStack.setCustomSpacing(Constants.topSpacing, after: spaceView)
        mainStack.addArrangedSubview(iconView)
        mainStack.setCustomSpacing(Constants.verticalSpacing, after: iconView)
        mainStack.addArrangedSubview(titleLabel)
        mainStack.addArrangedSubview(descriptionLabel)
        buttonsStack.addArrangedSubview(highlightedButton)
        
        if hasSecondButton {
            buttonsStack.addArrangedSubview(notNowButton)
        }
    }
    
    private func setupConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(Constants.heightNavigation)
        }
        
        buttonsStack.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-Constants.verticalSpacing)
            make.leading.trailing.equalToSuperview().inset(Constants.edgeSpacing)
        }
        
        lineSeparator.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.separatorHeight)
            make.bottom.equalTo(buttonsStack.snp.top).inset(-Constants.verticalSpacing)
        }
        
        mainStack.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(Constants.edgeSpacing)
            make.bottom.lessThanOrEqualTo(lineSeparator.snp.top).inset(-Constants.verticalSpacing)
        }
        
        iconView.snp.makeConstraints { make in
            make.size.equalTo(Constants.iconSize)
        }
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        descriptionLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
        
        titleLabel.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(FontSizeDS.title5.rawValue)
        }
        descriptionLabel.snp.makeConstraints { make in
            make.height.greaterThanOrEqualTo(FontSizeDS.body1.rawValue)
        }
    }
    
    private func resetComponents() {
        navigationBar.removeFromSuperview()
        
        buttonsStack.arrangedSubviews.forEach { view in
            mainStack.removeArrangedSubview(view)
            view.removeFromSuperview()
            view.snp.removeConstraints()
        }
        
        lineSeparator.removeFromSuperview()
        
        mainStack.arrangedSubviews.forEach { view in
            mainStack.removeArrangedSubview(view)
            view.removeFromSuperview()
            view.snp.removeConstraints()
        }
    }
}
