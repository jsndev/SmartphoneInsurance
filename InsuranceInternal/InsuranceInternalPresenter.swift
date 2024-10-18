//
//  InsuranceInternalPresenter.swift
//  Smartphone
//
//  Created by Dennis Torres on 02/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

import Foundation

protocol InsuranceInternalPresenting: AnyObject {
    var viewController: InsuranceInternalDisplaying? { get set }
}

final class InsuranceInternalPresenter {
    weak var viewController: InsuranceInternalDisplaying?
    private let coordinator: InsuranceInternalCoordinating

    init(coordinator: InsuranceInternalCoordinating) {
        self.coordinator = coordinator
    }
}

extension InsuranceInternalPresenter: InsuranceInternalPresenting {}
