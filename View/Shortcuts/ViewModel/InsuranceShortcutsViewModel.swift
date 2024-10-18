//
//  InsuranceShortcutsViewModel.swift
//  Smartphone
//
//  Created by Hugo Hernany da Silva Cabral on 07/04/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Components
import Core
import Insurance

class InsuranceShortcutsViewModel: InsuranceShortcutsViewModelProtocol {
    // MARK: - Properties

    var shortcutsModel: InsuranceShortcutsModelProtocol
    var showSeparatorView: Bool
    var smartphoneInsuranceData: SmartphoneInsuranceData
    var canIHelpYouAction: CanIHelpYouWhatsAppCompletion
    var urls: InspectionURLS?
    
    let moreOptionsAction: SmartphoneMoreOptionsShortcutCompletion?

    // MARK: - Initializer

    /// Initializer
    /// - Parameters:
    ///   - shortcutsModel: Insurance Shorcuts Model
    ///   - showSeparatorView: Separator between views
    ///   - policyNumber: Policy Number for tracking
    ///   - urls: Urls for shortcuts
    init(shortcutsModel: InsuranceShortcutsModelProtocol = InsuranceShortcutsModel(), showSeparatorView: Bool = true, smartphoneInsuranceData: SmartphoneInsuranceData, urls: InspectionURLS?, canIHelpYouAction: @escaping CanIHelpYouWhatsAppCompletion, smartphoneShortcutActions: SmartphoneShortcutActions? = nil) {
        self.shortcutsModel = shortcutsModel
        self.showSeparatorView = showSeparatorView
        self.smartphoneInsuranceData = smartphoneInsuranceData
        self.canIHelpYouAction = canIHelpYouAction
        self.urls = urls
        self.moreOptionsAction = smartphoneShortcutActions?.moreOptionsShortcutAction
    }

    // MARK: - Public functions

    func smartphoneShortcutAction(model: ShortcutModel) {
        guard let shortcut = SmartphoneShortcutsLink(rawValue: model.link.value ?? String()), let name = model.title.value else { return }
        
        switch shortcut {
        case .insuranceClaim:
            openExternalURL(url: urls?.insuranceClaim ?? String())
        case .support:
            openCanIHelpYouWhatsApp(url: urls?.whatsapp ?? String())
        case .more:
            goToMoreOptions()
        case .faq:
            print("FAQ")
        case .contractedCoverage:
            print("Coberturas contratadas")
        }
        
        trackShortcut(name: name)
    }

    func trackShortcut(name: String) {
        if let policyNumber = smartphoneInsuranceData.fullPolicy {
            SmartphoneInsuranceAnalytics.trackSmartphoneShortcutAction(shortcutName: name, policyNumber: policyNumber)
        }
    }

    // MARK: - Public methods

    private func openExternalURL(url: String) {
        if let url = URL(string: url) {
            UIApplication.shared.open(url)
        }
    }

    private func openCanIHelpYouWhatsApp(url: String) {
        try? DataStorage.save(method: .normal, with: url, to: SmartphoneDataStorage.whatsappURLKey)
        canIHelpYouAction()
    }
}

extension InsuranceShortcutsViewModel {
    
    private func getPoliciesModel() -> [InsurancePolicyIdentifier] {
        var policiesModel: [InsurancePolicyIdentifier] = []
        
        policiesModel.append(.init(policyNumber: smartphoneInsuranceData.insurancePolicy ?? String(), branch: smartphoneInsuranceData.branch ?? String(), branchOffice: smartphoneInsuranceData.branchOffice ?? String()))
            
        return policiesModel
    }
    
    private func goToMoreOptions() {
        let parameter = InsuranceDetailsParameter(policies: getPoliciesModel(), product: .smartphone)
        moreOptionsAction?(parameter)
    }    
}
