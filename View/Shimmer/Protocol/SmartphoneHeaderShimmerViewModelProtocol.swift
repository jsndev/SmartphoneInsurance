//
//  SmartphoneHeaderShimmerViewModelProtocol.swift
//  Smartphone
//
//  Created by Hugo Hernany da Silva Cabral on 11/03/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Core

public protocol SmartphoneHeaderShimmerViewModelProtocol: BaseViewModel {
    /// Bool that define if show or hide shimmer / loading
    var isLoading: Dynamic<Bool> { get set }

    /// Initializer
    /// - Parameter isLoading: parameter to animate the shimmer
    init(isLoading: Bool)
}
