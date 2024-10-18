//
//  SmartphoneInstallmentsMessageViewModel.swift
//  Smartphone
//
//  Created by Hugo Hernany da Silva Cabral on 12/05/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Core
import DesignSystem

struct SmartphoneInstallmentsMessageViewModel: SmartphoneInstallmentsMessageViewModelProtocol {
    // MARK: - Properties

    let properties: MessagePropertiesViewModel
    let accessibilityViewModel: AccessibilityViewModel

    // MARK: - Initializer

    init(messageData: FinancialMessageData, action: MessageDetailsAction? = nil) {
        var buttonTitle: String?

        if case .policyPaidOff = messageData.type, action != nil {
            buttonTitle = LocalizableBundle.policyPaidOffButtonTitle.localize
        }

        properties = MessagePropertiesViewModel(messageData: messageData, title: nil, buttonTitle: buttonTitle, buttonAction: action)
        accessibilityViewModel = messageData.accessibilityViewModel
    }
}

// MARK: - Extensions

extension FinancialMessageType {
    var icon: Icons {
        switch self {
        case .policyPaidOff:
            return .checkedIcon
        case .pendingInstallments:
            return .alert
        case .nextInstallment:
            return .calendar
        case .currentInstallmentAwaitingPayment:
            return .wait
        }
    }

    func getAttributes(_ fontStyleAndName: FontStyleAndName) -> [NSAttributedString.Key: Any] {
        let foregroundColor: UIColor

        switch self {
        case .policyPaidOff, .nextInstallment, .currentInstallmentAwaitingPayment:
            foregroundColor = .brandColorSecondary
        case .pendingInstallments:
            foregroundColor = .neutralColorGrey01
        }

        return [
            .font: UIFont(name: fontStyleAndName, size: .minimum) as Any,
            .foregroundColor: foregroundColor
        ]
    }
}

extension FinancialMessageData {
    var accessibilityViewModel: AccessibilityViewModel {
        let labelText: String
        var messageValue = value

        if messageValue.hasSuffix(",00") {
            messageValue.removeLast(3)
        }

        switch type {
        case .policyPaidOff:
            labelText = AccessibilityLocalizableBundle.policyPaidOff.accessibilityLocalize
        case .pendingInstallments:
            labelText = AccessibilityLocalizableBundle.pendingInstallments.accessibilityLocalize
        case .nextInstallment:
            labelText = String(format: AccessibilityLocalizableBundle.currentInstallment.accessibilityLocalize, messageValue, date)
        case .currentInstallmentAwaitingPayment:
            labelText = String(format: AccessibilityLocalizableBundle.currentInstallmentAwaitingPayment.accessibilityLocalize, date)
        }

        return .init(label: labelText, traits: .none)
    }

    var attributedMessage: NSAttributedString {
        let regularAttributes = type.getAttributes(.regular)
        let boldAttributes = type.getAttributes(.bold)

        let mutableString = NSMutableAttributedString()

        switch type {
        case .policyPaidOff:
            mutableString.append(.init(string: LocalizableBundle.policyPaidOff.localize, attributes: regularAttributes))
        case .pendingInstallments:
            mutableString.append(.init(string: LocalizableBundle.pendingInstallments.localize, attributes: regularAttributes))
        case .nextInstallment:
            let nextInstallmentMessage = buildNextInstallmentMessage(boldAttributes, regularAttributes)
            mutableString.append(nextInstallmentMessage)
        case .currentInstallmentAwaitingPayment:
            mutableString.append(.init(string: LocalizableBundle.currentInstallmentAwaitingPayment.localize, attributes: regularAttributes))
            mutableString.append(.init(string: date, attributes: boldAttributes))
        }

        return mutableString
    }

    private func buildNextInstallmentMessage(_ boldAttributes: [NSAttributedString.Key: Any], _ regularAttributes: [NSAttributedString.Key: Any]) -> NSAttributedString {
        let nextInstallmentMessage = NSMutableAttributedString()

        let moneyValue = String(format: LocalizableBundle.moneyValue.localize, value)
        nextInstallmentMessage.append(.init(string: LocalizableBundle.currentInstallmentValue.localize, attributes: regularAttributes))
        nextInstallmentMessage.append(.init(string: moneyValue, attributes: boldAttributes))
        nextInstallmentMessage.append(.init(string: LocalizableBundle.currentInstallmentDate.localize, attributes: regularAttributes))
        nextInstallmentMessage.append(.init(string: date, attributes: boldAttributes))

        return nextInstallmentMessage
    }
}
