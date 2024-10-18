//
//  InsuranceShortcutsModel.swift
//  Smartphone
//
//  Created by Hugo Hernany da Silva Cabral on 06/04/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Components
import Core
import DesignSystem

/// Typealias for the completion when the header is collapsed or expanded
public typealias SmartphoneShortcutActionCompletion = ((_ model: ShortcutModel) -> Void)

protocol InsuranceShortcutsModelProtocol {
    var shortcutItems: [ShortcutModel] { get set }
}

/// Smartphone Shortcuts
public enum SmartphoneShortcutsLink: String {
    case insuranceClaim = "acionar-sinistro"
    case support = "atendimento"
    case more = "mais"
    case faq
    case contractedCoverage = "coberturas-contratadas"
}

struct InsuranceShortcutsModel: InsuranceShortcutsModelProtocol {
    var shortcutItems: [ShortcutModel] = []

    init() {
        var items: [ShortcutModel] = []

        if FeatureToggle.isAvailable(.smartphoneHasPolicyShortcut) {
            items.append(createItem(itemTitle: LocalizableBundle.smartphoneInsuranceClaimShortcutTitle.localize, itemLink: SmartphoneShortcutsLink.insuranceClaim.rawValue, icon: Icons.smartphoneAlert))
            items.append(createItem(itemTitle: LocalizableBundle.smartphoneMyInsuranceShortcutTitle.localize, itemLink: SmartphoneShortcutsLink.more.rawValue, icon: Icons.arrowMore, type: .more))
        } else {
            items.append(createItem(itemTitle: LocalizableBundle.smartphoneInsuranceClaimShortcutTitle.localize, itemLink: SmartphoneShortcutsLink.insuranceClaim.rawValue, icon: Icons.smartphoneAlert))
            items.append(createItem(itemTitle: LocalizableBundle.smartphoneSupportShortcutTitle.localize, itemLink: SmartphoneShortcutsLink.support.rawValue, icon: Icons.costumerService))
        }

        shortcutItems = items
    }

    private func createItem(itemTitle: String, itemLink: String, icon: Icons, type: ShortcutType = .shortcut) -> ShortcutModel {
        let itemAccessibility = AccessibilityViewModel(label: itemTitle, traits: .button)
        let shortcutItem = ShortcutModel(icon: icon.codeToIcon, title: itemTitle, link: itemLink, type: type, isLoading: false, accessibility: itemAccessibility)
        return shortcutItem
    }
}
