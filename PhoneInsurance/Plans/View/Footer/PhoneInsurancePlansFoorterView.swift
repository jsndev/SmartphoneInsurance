//
//  PhoneInsurancePlansFoorterView.swift
//  Smartphone
//
//  Created by Jeff on 08/11/24.
//

import UIKit
import SnapKit
import DesignSystem

typealias DataFooter = PhoneInsurancePlansFoorterView.Model

final class PhoneInsurancePlansFoorterView: UIView, ConfigurableView {
    
    private enum Layout {
        enum Padding {
            static let viewMargin: CGFloat = 16
        }
        
        enum Strings {
            static let continueButtonTitle: String = "Continuar"
        }
    }
    // MARK: - Model
    struct Model {
        let description: String
        let hyperlink: String
        let linkURL: String
        let detail: DetailsModel
    }

    // MARK: - Views
    
    private lazy var continueButton: PortoButton = {
        let button = PortoButton.instantiate(viewModel: PortoButtonViewModel(
            accessibleTitle: Layout.Strings.continueButtonTitle,
            type: .primary,
            style: .tall)) { [weak self] _ in
                guard let self = self else { return }
                self.continueButtonPressed()
            }
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    
    private lazy var topBorder: UIView = {
        let view = UIView()
        view.backgroundColor = .black30
        return view
    }()

    
    private lazy var conditionsView: ConditionsView = {
        let view = ConditionsView()
        return view
    }()
    
    private lazy var installmentSummaryView = InstallmentSummaryView()


    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        layoutMargins = UIEdgeInsets(
            top: Layout.Padding.viewMargin,
            left: Layout.Padding.viewMargin,
            bottom: Layout.Padding.viewMargin,
            right: Layout.Padding.viewMargin
        )
        
        buildViewHierarchy()
        buildViewConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Configuration
    func configure(with model: DataFooter) {
        conditionsView.configure(with: model.description, hyperlink: model.hyperlink, linkURL: model.linkURL)
        installmentSummaryView.configure(with: model.detail)
    }

    // MARK: - Private Methods
    private func buildViewHierarchy() {
        addSubview(topBorder)
        addSubview(installmentSummaryView)
        addSubview(continueButton)
        addSubview(conditionsView)
    }

    private func buildViewConstraints() {
        topBorder.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
            $0.bottom.equalTo(installmentSummaryView.snp.top).offset(-12)
        }
        
        installmentSummaryView.snp.makeConstraints {
            $0.leading.trailing.equalTo(layoutMarginsGuide)
            $0.bottom.equalTo(continueButton.snp.top).offset(-8)
        }
        
        continueButton.snp.makeConstraints {
            $0.leading.trailing.equalTo(layoutMarginsGuide)
            $0.bottom.equalTo(conditionsView.snp.top).offset(-12)
        }
        
        conditionsView.snp.makeConstraints {
            $0.leading.trailing.equalTo(layoutMarginsGuide)
            $0.bottom.equalToSuperview().offset(-20)
        }
    }
    
    private func continueButtonPressed() {
        //: TODO
        print("Tela de confirmação")
    }
}
