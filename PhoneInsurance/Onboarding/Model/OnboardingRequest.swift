//
//  OnboardingRequest.swift
//  Smartphone
//
//  Created by Dennis Torres on 02/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

import Foundation

// MARK: - OnboardingRequest

struct OnboardingRequest: Encodable {
    let manufacturer: String
    let model: String
    let internalStorage: String
    
    enum CodingKeys: String, CodingKey {
        case manufacturer = "descricaoModeloOuMarca"
        case model = "nomeModeloDescricaoReferencia"
        case internalStorage = "capacidade"
    }
}
