//
//  InsuranceInternalInteractor.swift
//  Smartphone
//
//  Created by Dennis Torres on 02/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

import Foundation

protocol InsuranceInternalInteracting: AnyObject {
    func prepare()
}

final class InsuranceInternalInteractor {
    private let service: InsuranceInternalServicing
    private let presenter: InsuranceInternalPresenting

    init(service: InsuranceInternalServicing, presenter: InsuranceInternalPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

extension InsuranceInternalInteractor: InsuranceInternalInteracting {
    func prepare() {
        //service.fetch()
    }
}
