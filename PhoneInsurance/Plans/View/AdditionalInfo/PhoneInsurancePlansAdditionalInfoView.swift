//
//  PhoneInsurancePlansAdditionalInfoView.swift
//  Smartphone
//
//  Created by Jeff on 06/11/24.
//

import DesignSystem

final class PhoneInsurancePlansAdditionalInfoView: UIView, ConfigurableView {
    struct Model {
        let text: String
    }

    // MARK: - Layout Constants

    private enum Layout {
        enum Padding {
            static let viewMargin: CGFloat = 16
        }
    }

    // MARK: - Views

    private lazy var infoContainerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1 / UIScreen.main.scale
        view.layer.borderColor = UIColor.black30.cgColor
        view.layer.cornerRadius = 8
        return view
    }()

    private lazy var infoLabel: UILabel = {
        UILabel.makeLabel(font: .caption(.regular), numberOfLines: 0).apply {
            $0.textColor = .black75
            $0.textAlignment = .left
        }
    }()

    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutMargins = UIEdgeInsets(
            top: Layout.Padding.viewMargin,
            left: Layout.Padding.viewMargin,
            bottom: Layout.Padding.viewMargin,
            right: Layout.Padding.viewMargin
        )

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods

    private func setupView() {
        addSubview(infoContainerView)
        infoContainerView.addSubview(infoLabel)

        infoContainerView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        infoLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(16)
        }
    }

    // MARK: - Configuration

    func configure(with model: Model) {
        infoLabel.text = model.text
    }
}
