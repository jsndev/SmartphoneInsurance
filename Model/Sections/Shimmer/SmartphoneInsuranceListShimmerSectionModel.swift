//
//  SmartphoneInsuranceListShimmerSectionModel.swift
//  Smartphone
//
//  Created by Hugo Hernany da Silva Cabral on 06/05/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Components

/// Section model related to shimmering the smartphone list.
struct SmartphoneInsuranceListShimmerSectionModel: ExpandableTableViewCellModelProtocol {
    var headerView: UIView
    var contentViews: [UIView]
    var isExpanded: Bool

    init() {
        let header = SmartphoneHeaderShimmerView()
        header.setup()

        headerView = header
        contentViews = []
        isExpanded = false
    }
}
