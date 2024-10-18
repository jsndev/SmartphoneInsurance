//
//  InsuranceRemainingDaysViewModelProtocol.swift
//  Smartphone
//
//  Created by Hugo Hernany da Silva Cabral on 08/04/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Core

protocol InsuranceRemainingDaysViewModelProtocol: BaseViewModel {
    /// Days remaining of policy insurance coverage
    var daysRemaining: String? { get }
}
