//
//  OnboardingParameters.swift
//  Smartphone
//
//  Created by Dennis Torres on 03/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

import Foundation

// MARK: - OnboardingParameters

struct OnboardingParameters: Encodable {
    let manufacturer: String
    let model: String
    let internalStorage: String
    let cupomDesconto: String?
}
