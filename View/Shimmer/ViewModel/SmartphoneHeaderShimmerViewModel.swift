//
//  SmartphoneHeaderShimmerViewModel.swift
//  Smartphone
//
//  Created by Hugo Hernany da Silva Cabral on 11/03/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Core

struct SmartphoneHeaderShimmerViewModel: SmartphoneHeaderShimmerViewModelProtocol {
    public var isLoading = Dynamic<Bool>(false)

    init(isLoading: Bool = false) {
        self.isLoading.value = isLoading
    }
}
