//
//  BenefitsResponse.swift
//  Smartphone
//
//  Created by Dennis Torres on 02/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

import Foundation

// MARK: - Typealias LoadingProgressResponse

typealias LoadingProgressResponse = (
    benefits: [CellPhoneBenefitsResponse]?,
    progress: [String]?
)

// MARK: - BenefitsResponse

struct BenefitsResponse: Decodable, Equatable {
    let mainTitle: String?
    let cellPhoneBenefits: [CellPhoneBenefitsResponse]?
    let buttonData: ButtonInfoResponse?
    let loadingComponents: [CellPhoneBenefitsResponse]?
    let progressDescriptions: [String]?
    
    enum CodingKeys: String, CodingKey {
        case mainTitle
        case cellPhoneBenefits = "cellPhoneInsuranceBenefits"
        case buttonData = "button"
        case loadingComponents = "loadings"
        case progressDescriptions
    }
}


// MARK: - CellPhoneBenefitsResponse

struct CellPhoneBenefitsResponse: Decodable, Equatable {
    let icon: String?
    let title: String?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case icon = "iconCode"
        case title
        case description
    }
}


// MARK: - ButtonInfoResponse

struct ButtonInfoResponse: Decodable, Equatable {
    let title: String?
    let evLabel: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "buttonTitle"
        case evLabel = "tagging"
    }
}
