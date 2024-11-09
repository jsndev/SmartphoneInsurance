import DesignSystem
import Core
import UIKit

typealias DetailsModel = PhoneInsurancePlansDetailsView.Model

class PhoneInsurancePlansDetailsView: UIView, ConfigurableView {

    // MARK: - Layout Constants
    
    private enum Layout {
        enum Spacing {
            static let contentStack: CGFloat = 16
            static let installmentEditStack: CGFloat = 8
            static let discountDetailsLabelOffset: CGFloat = 3
            static let discountDetailsViewTop: CGFloat = 16
            static let installmentEditStackTop: CGFloat = 8
        }
        
        enum Padding {
            static let discountDetailsHorizontal: CGFloat = 8
            static let viewMargin: CGFloat = 16
        }
        
        enum CornerRadius {
            static let defaultRadius: CGFloat = 4
            static let viewRadius: CGFloat = 6
        }
        
        enum Inset {
            static let fullPaymentLabelBottom: CGFloat = 16
        }
    }
    
    // MARK: - Subviews
    
    private lazy var titleLabel: UILabel = .makeLabel(
        font: .title6(.bold),
        numberOfLines: 0
    )
    
    private lazy var phoneIconLabel: UILabel = .makeIconLabel(
        size: FontSizeDS.title5.rawValue
    )
    
    private lazy var descriptionLabel: UILabel = .makeLabel(
        font: .body2(.regular),
        numberOfLines: 1
    )
    
    private lazy var editDeviceButton: UILabel = .makeIconLabel(
        icon: Icons.edit.codeToIcon,
        size: FontSizeDS.caption.rawValue
    ).apply {
        $0.textColor = .portoSeguros100
        $0.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleEditDeviceButtonTapped))
        $0.addGestureRecognizer(tapGesture)
    }

    private lazy var contentStackView: UIStackView = .makeStackView(
        axis: .horizontal,
        spacing: Layout.Spacing.contentStack
    )
    
    private lazy var discountDetailsLabel: UILabel = .makeLabel(
        font: .label(.bold),
        numberOfLines: 1
    ).apply {
        $0.textAlignment = .left
        $0.backgroundColor = .green30
        $0.layer.cornerRadius = Layout.CornerRadius.defaultRadius
        $0.textColor = .green100
        $0.layer.masksToBounds = true
    }
    
    private lazy var discountDetailsView: UIView = {
        let view = UIView()
        view.backgroundColor = .green30
        view.layer.cornerRadius = Layout.CornerRadius.defaultRadius
        view.layer.masksToBounds = true
        return view
    }()

    private lazy var installmentSummaryView = InstallmentSummaryView()
    
    private lazy var editInstallmentsButton: UILabel = .makeIconLabel(
        icon: Icons.edit.codeToIcon,
        size: FontSizeDS.caption.rawValue
    ).apply {
        $0.textColor = .portoSeguros100
        $0.isHidden = !FeatureToggle.isAvailable(.ftEnableEditInstallmentsButton)
        $0.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleEditInstallmentsButtonTapped))
        $0.addGestureRecognizer(tapGesture)

    }
    
    private lazy var installmentEditStackView: UIStackView = .makeStackView(
        axis: .horizontal,
        spacing: Layout.Spacing.installmentEditStack
    )
    
    private lazy var fullPaymentLabel: UILabel = .makeLabel(
        font: .label(.regular),
        numberOfLines: 1
    ).apply {
        $0.textColor = .black85
    }
    
    private lazy var insuranceDeviceSelectionBottomSheet: PortoBottomSheet = {
        guard let viewController = self.parentViewController else {
            return PortoBottomSheet()
        }

        let content = createBottomSheetContent()

        let component = PortoBottomSheet.instantiate(
            viewModel: PortoBottomSheetViewModel(
                viewController: viewController,
                customContent: content
            )
        )

        return component
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Methods

extension PhoneInsurancePlansDetailsView {
    
    // MARK: - Setup Methods
    
    private func setupView() {
        setupHierarchy()
        setupConstraints()
        setupAppearance()
    }

    // MARK: - View Hierarchy
    
    private func setupHierarchy() {
        addSubview(titleLabel)
        addSubview(contentStackView)
        addSubview(discountDetailsView)
        addSubview(installmentEditStackView)
        addSubview(fullPaymentLabel)
        
        contentStackView.addArrangedSubview(phoneIconLabel)
        contentStackView.addArrangedSubview(descriptionLabel)
        contentStackView.addArrangedSubview(editDeviceButton)
        
        discountDetailsView.addSubview(discountDetailsLabel)
        
        installmentEditStackView.addArrangedSubview(installmentSummaryView)
        installmentEditStackView.addArrangedSubview(editInstallmentsButton)
        
        phoneIconLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        phoneIconLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        descriptionLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        descriptionLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        editDeviceButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        editDeviceButton.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
    }

    // MARK: - Constraints
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(layoutMarginsGuide)
        }
        
        contentStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Layout.Padding.viewMargin)
            $0.leading.trailing.equalTo(layoutMarginsGuide)
        }
        
        discountDetailsLabel.snp.makeConstraints {
            $0.top.equalTo(discountDetailsView.snp.top).offset(Layout.Spacing.discountDetailsLabelOffset)
            $0.bottom.equalTo(discountDetailsView.snp.bottom).inset(Layout.Spacing.discountDetailsLabelOffset)
            $0.leading.equalTo(discountDetailsView.snp.leading).offset(Layout.Padding.discountDetailsHorizontal)
            $0.trailing.equalTo(discountDetailsView.snp.trailing).inset(Layout.Padding.discountDetailsHorizontal)
        }
        
        discountDetailsView.snp.makeConstraints {
            $0.top.equalTo(contentStackView.snp.bottom).offset(Layout.Spacing.discountDetailsViewTop)
            $0.leading.equalTo(layoutMarginsGuide)
            $0.trailing.equalTo(layoutMarginsGuide).inset(Layout.Padding.discountDetailsHorizontal)
        }
        
        installmentEditStackView.snp.makeConstraints {
            $0.top.equalTo(discountDetailsLabel.snp.bottom).offset(Layout.Spacing.installmentEditStackTop)
            $0.leading.trailing.equalTo(layoutMarginsGuide)
        }
        
        fullPaymentLabel.snp.makeConstraints {
            $0.top.equalTo(installmentEditStackView.snp.bottom)
            $0.leading.trailing.equalTo(layoutMarginsGuide)
            $0.bottom.equalToSuperview().inset(Layout.Inset.fullPaymentLabelBottom)
        }
    }

    // MARK: - Appearance
    
    private func setupAppearance() {
        layer.cornerRadius = Layout.CornerRadius.viewRadius
        layer.masksToBounds = true
        backgroundColor = .black05
        layoutMargins = UIEdgeInsets(
            top: Layout.Padding.viewMargin,
            left: Layout.Padding.viewMargin,
            bottom: Layout.Padding.viewMargin,
            right: Layout.Padding.viewMargin
        )
    }

    // MARK: - Actions
    
    @objc private func handleEditDeviceButtonTapped() {
        insuranceDeviceSelectionBottomSheet.show()
    }
    
    @objc private func handleEditInstallmentsButtonTapped() {
        EventBus.shared.editInstallments.send()
    }
    
    private func createBottomSheetContent() -> PlansBottomSheetView {
        let content = PlansBottomSheetView()
        content.continueButtonTapAction = { [weak self] in
            guard let self = self else { return }
            self.hideBottomSheet()
        }
        
        content.otherDeviceButtonTapAction = { [weak self] in
            guard let self = self else { return }
            self.performOtherDeviceAction()
        }
        return content
    }

    private func hideBottomSheet() {
        insuranceDeviceSelectionBottomSheet.hide()
    }

    private func performOtherDeviceAction() {
        hideBottomSheet()
        EventBus.shared.otherDeviceButtonTapAction.send()
    }
}

// MARK: - Public Methods

extension PhoneInsurancePlansDetailsView {
    
    // MARK: - Configure Method
    
    func configure(with model: DetailsModel) {
        titleLabel.text = model.title
        phoneIconLabel.text =  Icons(rawValue: model.phoneIcon)?.codeToIcon
        descriptionLabel.text = model.description
        discountDetailsLabel.text = model.discountDetails
        
        installmentSummaryView.configure(with: model)
        fullPaymentLabel.text = model.fullPayment
    }
}
