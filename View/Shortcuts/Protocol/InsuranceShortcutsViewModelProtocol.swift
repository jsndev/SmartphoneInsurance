//
//  InsuranceShortcutsViewModelProtocol.swift
//  Smartphone
//
//  Created by Hugo Hernany da Silva Cabral on 07/04/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Components
import Core

protocol InsuranceShortcutsViewModelProtocol: AnyObject, BaseViewModel {
    /// Shortcuts model
    var shortcutsModel: InsuranceShortcutsModelProtocol { get set }

    /// Hide or Show separator view
    var showSeparatorView: Bool { get set }

    /// Perform shotcuts actions
    func smartphoneShortcutAction(model: ShortcutModel)

    /// Track shortcut actions (Analytics)
    func trackShortcut(name: String)
}
