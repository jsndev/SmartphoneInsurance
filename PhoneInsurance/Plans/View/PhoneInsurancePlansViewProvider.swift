//
//  PhoneInsurancePlansViewProvider.swift
//  Smartphone
//
//  Created by Jeff on 06/11/24.
//

import Foundation
import DesignSystem

// MARK: - Subview Types

enum PhoneInsuranceSubviewType: CaseIterable {
    case insuranceDetails
    case paymentMethod
    case benefits
    case coverageDetails
    case additionalInfo
    case footer
}

// MARK: - View Provider

final class PhoneInsurancePlansViewProvider: PhoneInsurancePlansViewProviding {
    let context = PhoneInsuranceContext.shared
    
    func provideSubviews() -> [PhoneInsuranceSubviewType: UIView] {
        return [
            .insuranceDetails: PhoneInsurancePlansDetailsView(),
            .paymentMethod: PhoneInsurancePlansPaymentMethodView(),
            .benefits: PhoneInsurancePlansBenefitsView(),
            .coverageDetails: PhoneInsurancePlansBenefitsView(),
            .additionalInfo: PhoneInsurancePlansAdditionalInfoView(),
            .footer: PhoneInsurancePlansFoorterView()
        ]
    }

    
    func configureSubviews(with subviews: [PhoneInsuranceSubviewType: UIView]) {
        for (type, view) in subviews {
            switch type {
            case .insuranceDetails:
                if let insuranceDetailsView = view as? PhoneInsurancePlansDetailsView,
                   let plan = context.get(\.internalData?.plan),
                   let device = context.get(\.deviceData) {
    
                    let model = PhoneInsurancePlansDetailsView.Model(planResponse: plan, device: device)
                    insuranceDetailsView.configure(with: model)
                }
            case .paymentMethod:
                if let paymentMethodView = view as? PhoneInsurancePlansPaymentMethodView,
                   let cardList = context.get(\.cardList) {

                    let model = PhoneInsurancePlansPaymentMethodView.Model(from: cardList)
                    paymentMethodView.configure(with: model)
                }
            case .benefits:
                if let benefitsView = view as? PhoneInsurancePlansBenefitsView,
                   let advantages = context.get(\.internalData?.plan?.advantages) {
    
                    benefitsView.configure(with: advantages)
                }
            case .coverageDetails:
                if let coverageDetailsView = view as? PhoneInsurancePlansBenefitsView,
                   let coverages = context.get(\.internalData?.plan?.coverages) {
    
                    coverageDetailsView.configure(with: coverages)
                }
            case .additionalInfo:
                if let additionalInfoView = view as? PhoneInsurancePlansAdditionalInfoView ,
                   let learnMore = context.get(\.internalData?.plan?.learnMore),
                let description = learnMore.description {
                    let model = PhoneInsurancePlansAdditionalInfoView.Model(
                        text: description
                    )
                    additionalInfoView.configure(with: model)
                }

            case .footer:
                    if let footerView = view as? PhoneInsurancePlansFoorterView,
                       let conditions = context.get(\.internalData?.plan?.generalConditions),
                       let plan = context.get(\.internalData?.plan),
                       let device = context.get(\.deviceData) {
        
                        let detail = PhoneInsurancePlansDetailsView.Model(planResponse: plan, device: device)

                        let model = PhoneInsurancePlansFoorterView.Model(
                            description: conditions.description ?? "No description available",
                            hyperlink: conditions.hyperlink ?? "More details",
                            linkURL: conditions.detail?.link ?? "", 
                            detail: detail
                        )
                        
                        footerView.configure(with: model)
                    }
                }
            }
        }

}

