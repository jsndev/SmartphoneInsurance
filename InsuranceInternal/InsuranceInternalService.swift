//
//  InsuranceInternalService.swift
//  Smartphone
//
//  Created by Dennis Torres on 02/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

import Core
import Foundation
//import RequestKit

protocol InsuranceInternalServicing {}

final class InsuranceInternalService: BaseManager {
    private let provider: ApiProviderProtocol?

    required init(provider: ApiProviderProtocol? = nil) {
        self.provider = provider
    }
    
    public convenience init() {
        self.init(provider: nil)
    }
}

extension InsuranceInternalService: InsuranceInternalServicing {}
