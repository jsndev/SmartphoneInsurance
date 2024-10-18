//
//  BenefitsResponse.swift
//  Smartphone
//
//  Created by Dennis Torres on 02/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

import Foundation

// MARK: - BenefitsResponse

struct BenefitsResponse: Decodable {
    let mainTitle: String?
    let cellPhoneBenefits: [CellPhoneBenefitsResponse]?
    let buttonData: ButtonInfoResponse?
    let loadingComponents: [CellPhoneBenefitsResponse]?
    let progressDescription: [ProgressDescriptionResponse]?
    
    enum CodingKeys: String, CodingKey {
        case mainTitle, cellPhoneBenefits = "cellPhoneInsuranceBenefits", buttonData = "button", loadingComponents = "loadings", progressDescription
    }
}

// MARK: - CellPhoneBenefitsResponse

struct CellPhoneBenefitsResponse: Decodable {
    let icon: String?
    let title: String?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case icon = "iconCode", title, description
    }
}

// MARK: - ButtonInfoResponse

struct ButtonInfoResponse: Decodable {
    let title: String?
    let evLabel: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "buttonTitle", evLabel = "tagging"
    }
}

// MARK: - ProgressDescriptionResponse

struct ProgressDescriptionResponse: Decodable {
    let value: String?
    
    enum CodingKeys: String, CodingKey {
        case value = "description"
    }
}
