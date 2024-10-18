//
//  SmartphoneInstallmentsViewModelProtocol.swift
//  Smartphone
//
//  Created by Hugo Hernany da Silva Cabral on 06/05/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Components
import Core
import Insurance

/// Action for payment bar details button
typealias InstallmentsDetailsAction = (() -> Void)

struct InstallmentsPropertiesViewModel {
    enum InstallmentStatus {
        case paid
        case delayed
        case current
        case future
    }

    let titleRegular: String
    let titleBold: String
    let installmentsStatus: [InstallmentStatus]
    let buttonTitle: String?
    let buttonAction: InstallmentsDetailsAction?
}

protocol SmartphoneInstallmentsViewModelProtocol: BaseViewModel {
    /// View model for smartphone installments properties
    var properties: InstallmentsPropertiesViewModel? { get }

    /// Accessibility view model for smartphone installments
    var accessibilityViewModel: AccessibilityViewModel? { get }

    /// Control if view will show shimmer
    var isLoading: Dynamic<Bool> { get set }

    /// Initializer
    init(with dataModel: FinancialDetailsResponse?, action: InstallmentsDetailsAction?)
}
