//
//  SmartphoneInstallmentsMessageViewModelProtocol.swift
//  Smartphone
//
//  Created by Hugo Hernany da Silva Cabral on 12/05/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Core
import Insurance

/// Action for payment bar details button
typealias MessageDetailsAction = (() -> Void)

enum FinancialMessageType {
    case policyPaidOff
    case pendingInstallments
    case nextInstallment
    case currentInstallmentAwaitingPayment
}

struct FinancialMessageData {
    let value: String
    let date: String
    let type: FinancialMessageType

    init(value: String?, date: String?, type: FinancialMessageType) {
        self.value = value ?? "--"
        self.date = date ?? "--"
        self.type = type
    }
}

struct MessagePropertiesViewModel {
    let messageData: FinancialMessageData
    let title: NSAttributedString?
    let buttonTitle: String?
    let buttonAction: MessageDetailsAction?
}

protocol SmartphoneInstallmentsMessageViewModelProtocol: BaseViewModel {
    /// View model for policy financial message
    var properties: MessagePropertiesViewModel { get }

    /// Accessibility view model for policy financial message
    var accessibilityViewModel: AccessibilityViewModel { get }

    /// Initializer
    init(messageData: FinancialMessageData, action: MessageDetailsAction?)
}

extension FinancialMessageType {
    init(convertedFrom messageType: FinancialDetailsResponse.Message.MessageType) {
        switch messageType {
        case .awaitingConfirmation:
            self = .currentInstallmentAwaitingPayment
        case .unresolved:
            self = .nextInstallment
        }
    }
}
