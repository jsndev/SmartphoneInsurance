//
//  SmartphoneInsuranceHeaderViewModelProtocol.swift
//  Smartphone
//
//  Created by Hugo Hernany da Silva Cabral on 22/03/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Components
import Core

public protocol SmartphoneInsuranceHeaderViewModelProtocol {
    /// View model for `HeaderView` component.
    var headerViewModel: HeaderViewModelProtocol? { get }

    /// Header status
    var isExpanded: Dynamic<Bool?> { get set }

    /// Header status
    var status: InspectionStatus? { get }

    /// Update header status
    func updateHeaderStatus(isExpanded: Bool, type: SmartphoneContentType)
}
