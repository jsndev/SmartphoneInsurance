//
//  PhoneInsurancePlansPaymentMethodModel.swift
//  Smartphone
//
//  Created by Jeff on 08/11/24.
//

import Foundation

extension PhoneInsurancePlansPaymentMethodView {
    struct Model {
        let title: String = "Forma de pagamento"
        let icon: String
        let description: String

        enum CardFlag: String {
            case visa = "VISA"
            case mastercard = "MASTERCARD"
            
            var iconName: String {
                switch self {
                case .visa:
                    return "IconCreditCard-visa"
                case .mastercard:
                    return "IconCreditCard-master"
                }
            }
        }

        init(from cardResponses: [CardResponse]) {
            let randomCard = cardResponses.randomElement()!

            if let flagValue = randomCard.flag?.uppercased(), let cardFlag = CardFlag(rawValue: flagValue) {
                self.icon = cardFlag.iconName
            } else {
                self.icon = ""
            }
            
            self.description = "Cartão Porto Bank •••• \(randomCard.lastDigits ?? "****")"
        }
    }
}
