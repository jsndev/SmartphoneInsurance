//
//  InstallmentSummaryView.swift
//  Smartphone
//
//  Created by Jeff on 07/11/24.
//

import DesignSystem

class InstallmentSummaryView: UIView {
    // MARK: - Subviews
    private let installmentFirstLabel: UILabel = .makeLabel(
        font: .title6(.bold),
        numberOfLines: 1
    ).apply {
        $0.textAlignment = .left
    }
    
    private let installmentPartLabel: UILabel = .makeLabel(
        font: .body2(.regular),
        numberOfLines: 1
    ).apply {
        $0.textAlignment = .left
        $0.text = " / 1ª parcela"
    }
    
    private let installmentDetailsLabel: UILabel = .makeLabel(
        font: .body2(.regular),
        numberOfLines: 1
    ).apply {
        $0.textAlignment = .left
    }
    
    private let horizontalStackView: UIStackView = .makeStackView(
        axis: .horizontal,
        spacing: 2
    )

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setup Methods
    private func setupView() {
        addSubview(horizontalStackView)
        addSubview(installmentDetailsLabel)
        
        horizontalStackView.addArrangedSubview(installmentFirstLabel)
        horizontalStackView.addArrangedSubview(installmentPartLabel)
        
        // MARK: - Constraints
        horizontalStackView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
        }
        
        installmentDetailsLabel.snp.makeConstraints {
            $0.top.equalTo(horizontalStackView.snp.bottom)
            $0.leading.equalToSuperview()
            $0.trailing.lessThanOrEqualToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    // MARK: - Configure Method
    func configure(with model: DetailsModel) {
        installmentFirstLabel.text = String(model.installmentFirst)
        installmentDetailsLabel.text = model.installmentDetails
    }
}
