//
//  SmartphoneInsuranceListViewModelProtocol.swift
//  Smartphone
//
//  Created by Hugo Hernany da Silva Cabral on 10/03/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Components
import Core

/// Protocol for the Smarthpone  insurance list
public protocol SmartphoneInsuranceListViewModelProtocol: BaseViewModel {
    /// Loading flag
    var viewState: Dynamic<SmartphoneInsuranceListViewState> { get }
    var sectionModels: Dynamic<[ExpandableTableViewCellModelProtocol]> { get set }
    var smartphoneInsuranceData: [SmartphoneInsuranceData]? { get set }
    var productUnavailableCompletion: ProductUnavailableCompletion? { get }
    var noGeoLocationAction: GenericAction { get }
    var hasSmartphoneProduct: Bool { get }

    /// Fetches insurance status
    func fetchInsuranceStatus(forceUpdate: Bool)

    /// Update cell for collapse state
    func updateSectionModelsForCollapse(position: Int)

    /// Update cell for expand state
    func updateSectionModelsForExpand(position: Int)

    /// Analytics for expand and collapse cells
    func trackExpandAndCollapse(isExpanded: Bool, position: Int)
}
