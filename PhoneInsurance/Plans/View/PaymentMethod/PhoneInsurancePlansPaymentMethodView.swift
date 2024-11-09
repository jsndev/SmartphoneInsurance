import DesignSystem

typealias PaymentModel = PhoneInsurancePlansPaymentMethodView.Model

class PhoneInsurancePlansPaymentMethodView: UIView, ConfigurableView {
    
    // MARK: - Layout Constants
    
    private enum Layout {
        enum Padding {
            static let viewMargin: CGFloat = 16
        }
        
        enum CornerRadius {
            static let viewRadius: CGFloat = 6
        }
        
        enum FontSize {
            static let descriptionTextSize: CGFloat = FontSizeDS.body2.rawValue
        }

    }
    
    // MARK: - Subviews
    
    private lazy var titleLabel: UILabel = .makeLabel(
        font: .label(.regular),
        numberOfLines: 0
    )
    
    private lazy var creditCardFlagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { $0.size.equalTo(CGSize(width: 30, height: 30)) }
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = .makeLabel(
        font: .body2(.regular),
        numberOfLines: 1
    )
    
    private lazy var editCardButton: UILabel = .makeIconLabel(
        icon: Icons.edit.codeToIcon,
        size: FontSizeDS.caption.rawValue
    ).apply {
        $0.textColor = .portoSeguros100
        $0.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleEditCardButtonTapped))
        $0.addGestureRecognizer(tapGesture)
    }
    
    private lazy var insuranceCardSelectionBottomSheet: PortoBottomSheet = {
        guard let viewController = self.parentViewController else {
            return PortoBottomSheet()
        }

        let content = createBottomSheetContent()

        let component = PortoBottomSheet.instantiate(
            viewModel: PortoBottomSheetViewModel(
                viewController: viewController,
                accessibleTexts:PortoBottomSheetViewModel.AccessibleTexts(
                    primaryButtonText: "Confirmar"
                  ),
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

extension PhoneInsurancePlansPaymentMethodView {
    
    // MARK: - Setup Methods
    
    private func setupView() {
        setupHierarchy()
        setupConstraints()
        setupAppearance()
    }

    // MARK: - View Hierarchy
    
    private func setupHierarchy() {
        addSubview(titleLabel)
        addSubview(creditCardFlagImageView)
        addSubview(descriptionLabel)
        addSubview(editCardButton)
    }

    // MARK: - Constraints
    
    private func setupConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Layout.Padding.viewMargin)
            $0.leading.equalToSuperview().offset(Layout.Padding.viewMargin)
        }
        
        creditCardFlagImageView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel.snp.leading)
            $0.top.equalTo(titleLabel.snp.bottom).offset(6)
            $0.bottom.equalToSuperview().inset(Layout.Padding.viewMargin)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(creditCardFlagImageView.snp.trailing).offset(8)
            $0.centerY.equalTo(creditCardFlagImageView.snp.centerY)
            $0.trailing.lessThanOrEqualTo(editCardButton.snp.leading).offset(-8)
        }
        
        editCardButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(Layout.Padding.viewMargin)
            $0.centerY.equalTo(creditCardFlagImageView.snp.centerY)
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
    
    @objc private func handleEditCardButtonTapped() {
        insuranceCardSelectionBottomSheet.show()
    }
    
    private func createBottomSheetContent() -> UIView {
        let content = UIView()
        return content
    }

    private func hideBottomSheet() {
        insuranceCardSelectionBottomSheet.hide()
    }
}

// MARK: - Public Methods

extension PhoneInsurancePlansPaymentMethodView {
    
    // MARK: - Configure Method
    
    func configure(with model: PaymentModel) {
        titleLabel.text = model.title
        creditCardFlagImageView.image = UIImage(named: model.icon)
        descriptionLabel.attributedText = .getTextUsingBBCode(
            fullText: model.description,
            textSize: Layout.FontSize.descriptionTextSize
        )
    }
}
