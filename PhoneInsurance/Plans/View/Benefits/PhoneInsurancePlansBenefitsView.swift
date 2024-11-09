//
//  PhoneInsurancePlansBenefitsView.swift
//  Smartphone
//
//  Created by Jeff on 06/11/24.
//

import DesignSystem
import Core

class PhoneInsurancePlansBenefitsView: UIView {

    // MARK: - Enum
    
    private enum Constants {
        static let backgroundColor: UIColor = .white
        static let topSpacing: CGFloat = .spacing(.medium)
        static let bottomSpacing: CGFloat = .spacing(.extraSmall)
        static let verticalSpacing: CGFloat = 6
        static let horizontalSpacing: CGFloat = .spacing(.extraSmall)
        static let iconHintSize: CGFloat = .size(.smaller)
        static let iconTopicSize: CGFloat = 18
    }
    
    // MARK: - Subviews
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.verticalSpacing
        return stackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .body2(.bold)
        label.textColor = .black
        label.textAlignment = .left
        return label
    }()
    
    private lazy var hintIcon: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.setIconFont(size: Constants.iconHintSize)
        label.isHidden = !FeatureToggle.isAvailable(.ftEnableEditInstallmentsButton)

        label.textColor = .portoSeguros100
        label.snp.makeConstraints { make in
            make.size.equalTo(Constants.iconHintSize)
        }
        return label
    }()
    
    // MARK: - Internal properties
    
    @objc var hintAction: (() -> Void)?
    
    // MARK: - Private properties
    
    private var model: AdvantagesResponse?

    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        model = nil
        hintAction = nil
    }
}

// MARK: - ConfigurableView

extension PhoneInsurancePlansBenefitsView: ConfigurableView {
    func configure(with model: AdvantagesResponse?) {
        self.model = model
        
        resetComponents()
        setupHierarchy()
        setupElements()
        setupConstraints()
    }
}

// MARK: - Private methods

extension PhoneInsurancePlansBenefitsView {
    
    private func setupHierarchy() {
        addSubview(mainStackView)
        
        let titleStackV: UIStackView = .createEmptyStackView(
            customSpacing: .spacing(.nano),
            axis: .horizontal
        )
        titleStackV.alignment = .leading
        
        titleStackV.addArrangedSubview(titleLabel)
        titleStackV.addArrangedSubview(hintIcon)
        titleStackV.addArrangedSubview(UIView())
        
        mainStackView.addArrangedSubview(titleStackV)
    }
    
    private func setupElements() {
        backgroundColor = Constants.backgroundColor
        
        titleLabel.text = model?.title
        
        if let hintIconCode = model?.icon {
            hintIcon.text = Icons(rawValue: hintIconCode)?.codeToIcon
            setHintIconAction()
        }
        
        model?.items?.forEach { item in
            
            let topicStackV: UIStackView = .createEmptyStackView(
                customSpacing: Constants.horizontalSpacing,
                axis: .horizontal
            )
            topicStackV.alignment = .leading
            
            if let iconCode = item.icon {
                let iconView: UILabel = .makeTopicIcon(iconCode, Constants.iconTopicSize)
                topicStackV.addArrangedSubview(iconView)
            }
            
            let textView: UILabel = .makeTopicText(item.text)
            topicStackV.addArrangedSubview(textView)
            mainStackView.addArrangedSubview(topicStackV)
        }
    }
    
    private func setupConstraints() {
        mainStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.topSpacing)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(Constants.bottomSpacing)
        }
    }
    
    private func resetComponents() {
        mainStackView.arrangedSubviews.forEach { view in
            mainStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        mainStackView.removeFromSuperview()
    }
    
    private func setHintIconAction() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(getter: hintAction))
        tapGesture.numberOfTapsRequired = 1
        hintIcon.isUserInteractionEnabled = true
        hintIcon.addGestureRecognizer(tapGesture)
    }
}

// MARK: - UILabel Makers

extension UILabel {
    fileprivate static func makeTopicIcon(_ iconCode: String?, _ size: CGFloat) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.setIconFont(size: size)
        label.textColor = .portoSeguros100
        if let iconCode {
            label.text = Icons(rawValue: iconCode)?.codeToIcon
        }
        label.snp.makeConstraints { make in
            make.size.equalTo(size)
        }
        return label
    }
    
    fileprivate static func makeTopicText(_ text: String?) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = .zero
        label.font = .body2()
        label.textColor = .black
        label.text = text
        return label
    }
}
