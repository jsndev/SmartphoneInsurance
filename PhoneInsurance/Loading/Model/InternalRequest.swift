//
//  InternalRequest.swift
//  Smartphone
//
//  Created by Dennis Torres on 06/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

import Foundation

// MARK: - InternalRequest

struct InternalRequest: Encodable {
    let client: PhoneInsuranceClientRequest?
    let deviceData: DeviceDataResponse?
    let sessionId: String?
    let ipAddress: String?
    let coupon: String?
    
    enum CodingKeys: String, CodingKey {
        case client = "cliente",
             deviceData = "productDetail",
             sessionId,
             ipAddress,
             coupon
    }
}

// MARK: - PhoneInsuranceClientRequest

struct PhoneInsuranceClientRequest: Encodable {
    let cpf: String?
    let name: String?
    let socialName: String?
    let cellPhone: String?
    let email: String?
    let zipCode: String?
}
