//
//  SmartphoneInsuranceListViewState.swift
//  Smartphone
//
//  Created by Hugo Hernany da Silva Cabral on 10/03/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Components
import Core

/// States of SmartphoneInsuranceListView.
public enum SmartphoneInsuranceListViewState {
    // MARK: - Insurances

    /// Case for Empty State
    case none
    /// Case for Error State
    case error(ErrorViewModelProtocol?)
    /// Case for Loading State
    case loading
    /// Case for Reloading State
    case reloading
    /// Case for successful state
    case success([ExpandableTableViewCellModelProtocol])

    // MARK: - Installments

    /// Case for installments details
    case isFetchingInstallments
    /// Case for installments error
    case errorInstallmentsFetch
    /// Case for installments details
    case didFetchInstallments
}
