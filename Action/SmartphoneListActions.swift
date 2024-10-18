//
//  SmartphoneListActions.swift
//  Smartphone
//
//  Created by Hugo Hernany da Silva Cabral on 13/05/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Core
import Insurance

/// Typealias to pattern inspection flow completion
public typealias SmartphonePendingInspectionCompletion = (InspectionDataModel?, VerificationResultDelegate?) -> Void

/// Typrelias to open financial flow
public typealias SmartphoneFinancialDetailsCompletion = (_ parameter: FlutterFinancialParameter) -> Void

public typealias SmartphoneMoreOptionsShortcutCompletion = (_ parameter: InsuranceDetailsParameter) -> Void

public struct SmartphoneListActions {
    public let openInspectionAction: SmartphonePendingInspectionCompletion?
    public let financialDetailsAction: SmartphoneFinancialDetailsCompletion?
    public let productUnavailableCompletion: ProductUnavailableCompletion?
    public let smartphoneShortcutActions: SmartphoneShortcutActions?

    /// Initializer
    /// - Parameters:
    ///   - openInspectionAction: Open Inspection flow
    ///   - financialDetailsAction: Open policy installments details
    public init(openInspectionAction: SmartphonePendingInspectionCompletion?, financialDetailsAction: SmartphoneFinancialDetailsCompletion? = nil, productUnavailableCompletion: ProductUnavailableCompletion?, shortcutActions: SmartphoneShortcutActions?) {
        self.openInspectionAction = openInspectionAction
        self.financialDetailsAction = financialDetailsAction
        self.productUnavailableCompletion = productUnavailableCompletion
        self.smartphoneShortcutActions = shortcutActions
    }
}
