//
//  SmartphoneInstallmentsViewModel.swift
//  Smartphone
//
//  Created by Hugo Hernany da Silva Cabral on 06/05/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Core
import Insurance

struct SmartphoneInstallmentsViewModel: SmartphoneInstallmentsViewModelProtocol {
    // MARK: - Properties

    var isLoading = Dynamic<Bool>(true)

    var properties: InstallmentsPropertiesViewModel?

    var accessibilityViewModel: AccessibilityViewModel? {
        return getAccessibilityViewModel(for: properties?.installmentsStatus)
    }

    // MARK: - Initializer

    init(with dataModel: FinancialDetailsResponse?, action: InstallmentsDetailsAction? = nil) {
        guard let dataModel = dataModel else { return }

        // Title
        let titleRegular = LocalizableBundle.paymentBarTitleRegular.localize
        let titleBold = String(format: LocalizableBundle.paymentBarTitleBold.localize, dataModel.currentInstallment, LocalizableBundle.of.localize, dataModel.totalInstallments)

        // Installments status
        let installments: [InstallmentsPropertiesViewModel.InstallmentStatus] = dataModel.installments.map {
            switch $0.status {
            case .paid:
                return .paid
            case .open, .quarantine:
                return .current
            case .delayed:
                return .delayed
            case .future:
                return .future
            }
        }

        // Button
        let buttonTitle: String? = (action != nil) ? LocalizableBundle.paymentBarButtonTitle.localize : nil

        properties = .init(titleRegular: titleRegular, titleBold: titleBold, installmentsStatus: installments, buttonTitle: buttonTitle, buttonAction: action)
    }

    // MARK: - Private Methods
    // swiftlint:disable all
    private func getAccessibilityViewModel(for installments: [InstallmentsPropertiesViewModel.InstallmentStatus]?) -> AccessibilityViewModel? {
        guard let installments = installments else { return nil }

        let totalItems = installments.count
        let paidItems = installments.filter { $0 == .paid }.count
        let unpaidItems = installments.count - paidItems
        let accessibilityStringFormat = AccessibilityLocalizableBundle.paymentBarAccessibility.accessibilityLocalize

        let paidItemsPlural: (String, String, String) = paidItems == 1 ? ("i", "", "") : ("ram", "s", "s")
        let totalItemsPlural = totalItems == 1 ? "" : "s"
        let unpaidItemsPlural: (String, String, String, String) = unpaidItems == 1 ? ("", "", "", "") : ("m", "s", "em", "s")

        let formmatedAccessibilityString = String(format: accessibilityStringFormat, paidItemsPlural.0, paidItemsPlural.1, paidItems, paidItemsPlural.2, totalItems, totalItemsPlural, unpaidItemsPlural.0, unpaidItems, unpaidItemsPlural.1, unpaidItemsPlural.2, unpaidItemsPlural.3)

        return .init(label: formmatedAccessibilityString, traits: .none)
    }
}
