//
//  SmartphoneListCrossSellSectionModel.swift
//  Smartphone
//
//  Created by Hugo Hernany da Silva Cabral on 06/05/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Components
import Core

/// Section model related to present empty list view
struct SmartphoneListCrossSellSectionModel: ExpandableTableViewCellModelProtocol {
    var headerView = UIView()
    var contentViews: [UIView]
    var isExpanded: Bool
    
    init(url: String, delegate: CrossSellOffersViewDelegate? = nil) {
        contentViews = []
        isExpanded = false
        
        let crossSell = FeatureToggle.isAvailable(.smartphoneEmptyCrossSell) ? configureCrossSellOffersView(url: url, delegate: delegate) : configureCrossSellView()
        
        headerView = crossSell
    }
    
    private func configureCrossSellView() -> SmartphoneInsuranceCrossSellView {
        let crossSell = SmartphoneInsuranceCrossSellView()
        crossSell.setup()

        return crossSell
    }
    
    private func configureCrossSellOffersView (url: String, delegate: CrossSellOffersViewDelegate?) -> SmartphoneInsuranceCrossSellOffersView {
        let viewModel = SmartphoneInsuranceCrossSellOffersViewModel(quoteURL: url)
        let crossSell = SmartphoneInsuranceCrossSellOffersView()
        crossSell.setup(viewModel: viewModel)
        crossSell.delegate = delegate
        
        return crossSell
    }
}
