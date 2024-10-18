//
//  SmartphoneInsuranceAnalytics.swift
//  Smartphone
//
//  Created by Hugo Hernany da Silva Cabral on 09/04/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Core

protocol SmartphoneInsuranceAnalyticsProtocol {
    @discardableResult
    static func trackSmartphoneInsuranceViewItem(itemName: String, screenClass: String?) -> TrackingViewItem

    @discardableResult
    static func trackSmartphoneShortcutAction(shortcutName: String, policyNumber: String) -> TrackingAction

    @discardableResult
    static func trackCollapseExpandHeader(isExpanded: Bool, policyNumber: String) -> TrackingAction

    @discardableResult
    static func trackButtonAction(buttonName: String, policyNumber: String) -> TrackingAction

    @discardableResult
    static func trackPaymentBarSuccess(policyNumber: String, isDelayed: Bool, date: String?) -> TrackingAction

    @discardableResult
    static func trackPaymentBarError(policyNumber: String) -> TrackingAction
}

class SmartphoneInsuranceAnalytics: SmartphoneInsuranceAnalyticsProtocol {
    @discardableResult
    static func trackSmartphoneInsuranceViewItem(itemName: String, screenClass: String? = nil) -> TrackingViewItem {
        let trackViewItem = TrackingViewItem(section: AnalyticsSection.smartphoneHome.rawValue, itemName: itemName, platform: .native, screenClass: screenClass ?? String())
        trackViewItem.append(key: .action, value: AnalyticsActions.smartphoneAlert.rawValue)
        trackViewItem.append(key: AnalyticsKeys.event.rawValue, value: AnalyticsEvent.viewItem.rawValue)
        return SmartphoneAnalyticsTrack.getInspectionViewItemInformations(trackViewItem: trackViewItem)
    }

    @discardableResult
    static func trackCollapseExpandHeader(isExpanded: Bool, policyNumber: String) -> TrackingAction {
        let action = isExpanded ? AnalyticsActions.smartphoneExpandHeader.rawValue : AnalyticsActions.smartphoneCollapseHeader.rawValue
        let trackAction = TrackingAction(section: AnalyticsSection.smartphoneHome.rawValue, category: AnalyticsCategory.smartphoneHome.rawValue, action: action, itemName: AnalyticsItemName.smartphoneHome.rawValue)
        trackAction.append(key: AnalyticsKeys.event.rawValue, value: AnalyticsEvent.selectContent.rawValue)
        trackAction.append(key: .productIdentify, value: policyNumber)
        return getDeviceInformationsAnalytics(trackAction: trackAction)
    }

    @discardableResult
    static func trackSmartphoneShortcutAction(shortcutName: String, policyNumber: String) -> TrackingAction {
        let action = String(format: AnalyticsActions.smartphoneClickExpandableCardShortcuts.rawValue, shortcutName.normalizeValue)
        let trackAction = TrackingAction(section: AnalyticsSection.smartphoneHome.rawValue, category: AnalyticsCategory.smartphoneHome.rawValue, action: action, itemName: AnalyticsItemName.smartphoneHome.rawValue)
        trackAction.append(key: AnalyticsKeys.event.rawValue, value: AnalyticsEvent.selectContent.rawValue)
        trackAction.append(key: .productIdentify, value: policyNumber)

        return getDeviceInformationsAnalytics(trackAction: trackAction)
    }

    @discardableResult
    static func trackButtonAction(buttonName: String, policyNumber: String) -> TrackingAction {
        let action = String(format: AnalyticsActions.smartphoneClickExpandableCardButtonActions.rawValue, buttonName)
        let trackAction = TrackingAction(section: AnalyticsSection.smartphoneHome.rawValue, category: AnalyticsCategory.smartphoneHome.rawValue, action: action, itemName: AnalyticsItemName.smartphoneHome.rawValue)
        trackAction.append(key: AnalyticsKeys.event.rawValue, value: AnalyticsEvent.selectContent.rawValue)
        trackAction.append(key: .productIdentify, value: policyNumber)

        return getDeviceInformationsAnalytics(trackAction: trackAction)
    }

    @discardableResult
    static func trackPaymentBarSuccess(policyNumber: String, isDelayed: Bool, date: String?) -> TrackingAction {
        let isDelayedString = isDelayed ? AnalyticsValues.delayed.rawValue : AnalyticsValues.noPendency.rawValue
        let dueDay = String(date?.prefix(2) ?? Substring(AnalyticsValues.noDataReturn.rawValue))
        let productInvoice = String(format: AnalyticsValues.productInvoiceError.rawValue, isDelayedString, dueDay)

        let action = String(format: AnalyticsActions.smartphoneReturnExpandableCardPayments.rawValue, AnalyticsValues.success.rawValue)
        let trackAction = TrackingAction(section: AnalyticsSection.smartphoneHome.rawValue, category: AnalyticsCategory.smartphoneHome.rawValue, action: action, itemName: AnalyticsItemName.smartphoneHome.rawValue)
        trackAction.append(key: AnalyticsKeys.event.rawValue, value: AnalyticsEvent.selectContent.rawValue)
        trackAction.append(key: AnalyticsKeys.noInteraction.rawValue, value: AnalyticsValues.noInteractionTrue.rawValue)
        trackAction.append(key: .productInvoice, value: productInvoice)
        trackAction.append(key: .productIdentify, value: policyNumber)

        return getDeviceInformationsAnalytics(trackAction: trackAction)
    }

    @discardableResult
    static func trackPaymentBarError(policyNumber: String) -> TrackingAction {
        let action = String(format: AnalyticsActions.smartphoneReturnExpandableCardPayments.rawValue, AnalyticsValues.error.rawValue)
        let trackAction = TrackingAction(section: AnalyticsSection.smartphoneHome.rawValue, category: AnalyticsCategory.smartphoneHome.rawValue, action: action, itemName: AnalyticsItemName.smartphoneHome.rawValue)
        trackAction.append(key: AnalyticsKeys.event.rawValue, value: AnalyticsEvent.selectContent.rawValue)
        trackAction.append(key: AnalyticsMessages.errorMessage.rawValue, value: AnalyticsLabels.smartphoneInstallmentsErrorMessage.rawValue)
        trackAction.append(key: .productIdentify, value: policyNumber)

        return getDeviceInformationsAnalytics(trackAction: trackAction)
    }

    @discardableResult
    static func trackFinancialMessages(policyNumber: String, message: String) -> TrackingAction {
        let action = AnalyticsActions.smartphoneAlertExpandableCard.rawValue
        let trackAction = TrackingAction(section: AnalyticsSection.smartphoneHome.rawValue, category: AnalyticsCategory.smartphoneHome.rawValue, action: action, itemName: AnalyticsItemName.smartphoneHome.rawValue)

        trackAction.append(key: AnalyticsKeys.event.rawValue, value: AnalyticsEvent.selectContent.rawValue)
        trackAction.append(key: .productIdentify, value: policyNumber)
        trackAction.append(key: AnalyticsKeys.evLabel.rawValue, value: message)
        trackAction.append(key: .alert, value: String(format: AnalyticsAlert.smarphoneAlert.rawValue, message))

        return getDeviceInformationsAnalytics(trackAction: trackAction)
    }

    // MARK: - Private functions

    @discardableResult
    private static func getDeviceInformationsAnalytics(trackAction: TrackingAction) -> TrackingAction {
        trackAction.append(key: .product, value: AnalyticsProduct.smartphoneInsurance.rawValue)

        CoreAnalytics.tracker?.trackAction(with: trackAction)
        return trackAction
    }
}
