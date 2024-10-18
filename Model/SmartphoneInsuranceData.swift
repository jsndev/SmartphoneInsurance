//
//  SmartphoneInsuranceData.swift
//  Smartphone
//
//  Created by Andre Casarini on 08/04/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Foundation

/// Model for the Smartphone Insurance Data
public struct SmartphoneInsuranceData {
    // MARK: - Properties

    var insuranceHolder: String?
    var insurancePolicy: String?
    var fullPolicy: String?
    var coverage: Int?
    var branch: String?
    var branchOffice: String?
    
    // MARK: - Initializers

    /// Initializer
    /// - Parameters:
    ///   - insuranceHolder: Holder name
    ///   - insurancePolicy: The number of the policy
    ///   - fullPolicy: The complete number of the policy
    ///   - coverage: days of coverage
    ///   - branch: branch of polyce
    ///   - branchOffice: office of branch
    public init(insuranceHolder: String?, insurancePolicy: String?, fullPolicy: String?, coverage: Int?, branch: String?, branchOffice: String?) {
        self.insuranceHolder = insuranceHolder
        self.coverage = coverage
        self.insurancePolicy = insurancePolicy
        self.fullPolicy = fullPolicy
        self.branch = branch
        self.branchOffice = branchOffice
    }
}
