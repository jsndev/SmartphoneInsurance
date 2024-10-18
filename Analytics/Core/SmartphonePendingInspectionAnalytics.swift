//
//  SmartphoneInsuranceAnalyticsProtocol.swift
//  Smartphone
//
//  Created by Hugo Hernany da Silva Cabral on 12/03/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Core

protocol SmartphonePendingInspectionAnalyticsProtocol {
    @discardableResult
    static func trackSmartphonePedingValidationViewItem(itemName: String, screenClass: String?, deviceInformation: SmartphoneDeviceInformationAnalyticsProtocol?) -> TrackingViewItem

    @discardableResult
    static func trackSmartphoneLoadingViewItem(itemName: String, screenClass: String?, deviceInformation: SmartphoneDeviceInformationAnalyticsProtocol?) -> TrackingViewItem

    @discardableResult
    static func trackSmartphoneValidationAction(deviceInformation: SmartphoneDeviceInformationAnalyticsProtocol?) -> TrackingAction

    @discardableResult
    static func trackCollapseExpandHeader(isExpanded: Bool, deviceInformation: SmartphoneDeviceInformationAnalyticsProtocol?) -> TrackingAction
}

class SmartphonePendingInspectionAnalytics: SmartphonePendingInspectionAnalyticsProtocol {
    @discardableResult
    static func trackCollapseExpandHeader(isExpanded: Bool, deviceInformation: SmartphoneDeviceInformationAnalyticsProtocol?) -> TrackingAction {
        let action = isExpanded ? AnalyticsActions.smartphoneExpandHeader.rawValue : AnalyticsActions.smartphoneCollapseHeader.rawValue
        let trackAction = TrackingAction(section: AnalyticsSection.smartphoneHome.rawValue, category: AnalyticsCategory.smartphoneHome.rawValue, action: action, itemName: AnalyticsItemName.smartphoneHome.rawValue)
        return getDeviceInformationsAnalytics(deviceInformation: deviceInformation, trackAction: trackAction)
    }

    @discardableResult
    static func trackSmartphonePedingValidationViewItem(itemName: String, screenClass: String? = nil, deviceInformation: SmartphoneDeviceInformationAnalyticsProtocol? = nil) -> TrackingViewItem {
        let trackViewItem = TrackingViewItem(section: AnalyticsSection.smartphoneHome.rawValue, itemName: itemName, platform: .native, screenClass: screenClass ?? String())

        trackViewItem.append(key: .action, value: AnalyticsActions.smartphoneAlert.rawValue)
        trackViewItem.append(key: AnalyticsKeys.event.rawValue, value: AnalyticsEvent.selectContent.rawValue)

        if let deviceManufacture = deviceInformation?.manufacturer, let deviceModel = deviceInformation?.model {
            let productCategoryValue = "\(deviceManufacture) \(deviceModel)".normalizeValue
            trackViewItem.append(key: AnalyticsKeys.productCategory.rawValue, value: productCategoryValue)
        }

        return SmartphoneAnalyticsTrack.getInspectionViewItemInformations(deviceInformation: deviceInformation, trackViewItem: trackViewItem)
    }

    @discardableResult
    static func trackSmartphoneLoadingViewItem(itemName: String, screenClass: String? = nil, deviceInformation: SmartphoneDeviceInformationAnalyticsProtocol? = nil) -> TrackingViewItem {
        let trackViewItem = TrackingViewItem(section: AnalyticsSection.smartphoneHome.rawValue, itemName: itemName, platform: .native, screenClass: screenClass ?? String())

        trackViewItem.append(key: .action, value: AnalyticsActions.smartphoneShimmer.rawValue)
        trackViewItem.append(key: AnalyticsKeys.event.rawValue, value: AnalyticsEvent.selectContent.rawValue)

        return SmartphoneAnalyticsTrack.getInspectionViewItemInformations(deviceInformation: deviceInformation, trackViewItem: trackViewItem)
    }

    @discardableResult
    static func trackSmartphoneValidationAction(deviceInformation: SmartphoneDeviceInformationAnalyticsProtocol? = nil) -> TrackingAction {
        let trackAction = TrackingAction(section: AnalyticsSection.smartphoneHome.rawValue, category: AnalyticsCategory.smartphoneHome.rawValue, action: AnalyticsActions.smartphonePendingValidationValidate.rawValue, itemName: AnalyticsItemName.smartphoneHome.rawValue)

        return getDeviceInformationsAnalytics(deviceInformation: deviceInformation, trackAction: trackAction)
    }

    // MARK: - Private functions

    @discardableResult
    private static func getDeviceInformationsAnalytics(deviceInformation: SmartphoneDeviceInformationAnalyticsProtocol? = nil, trackAction: TrackingAction) -> TrackingAction {
        trackAction.append(key: AnalyticsKeys.event.rawValue, value: AnalyticsEvent.selectContent.rawValue)
        trackAction.append(key: .product, value: AnalyticsProduct.smartphoneInsurance.rawValue)

        if let deviceManufacture = deviceInformation?.manufacturer, let deviceModel = deviceInformation?.model {
            let deviceInfosString = "\(deviceManufacture) \(deviceModel)".normalizeValue
            trackAction.append(key: AnalyticsKeys.productCategory.rawValue, value: deviceInfosString)
            trackAction.append(key: AnalyticsKeys.evLabel.rawValue, value: deviceInfosString)
        }

        CoreAnalytics.tracker?.trackAction(with: trackAction)
        return trackAction
    }
}
