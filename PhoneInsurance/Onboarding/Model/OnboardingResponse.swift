//
//  OnboardingResponse.swift
//  Smartphone
//
//  Created by Dennis Torres on 02/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

import Foundation

// MARK: - OnboardingDataResponse

struct OnboardingDataResponse: Decodable, Equatable {
    let benefits: BenefitsResponse
    let personData: PersonDataResponse?
    let deviceData: DeviceDataResponse?
    let cardList: [CardResponse]?
    
    enum CodingKeys: String, CodingKey {
        case benefits,
             personData,
             deviceData = "productDetail",
             cardList = "cards"
    }
}

// MARK: - PersonDataResponse

struct PersonDataResponse: Decodable, Equatable {
    let roleCode: String?
    let birthDate: String?
    let email: String?
    let address: AddressResponse?
    let maritalStatus: String?
    let name: String?
    let treatmentName: String?
    let documentNumber: String?
    let personCode: Int?
    let gender: String?
    let phone: PhoneResponse?
    let personType: String?
    
    enum CodingKeys: String, CodingKey {
        case roleCode = "codigoPapel"
        case birthDate = "dataNascimento"
        case email
        case address = "endereco"
        case maritalStatus = "estadoCivil"
        case name = "nome"
        case treatmentName = "nomeTratamento"
        case documentNumber = "numDocumento"
        case personCode = "pescod"
        case gender = "sexo"
        case phone = "telefone"
        case personType = "tipoPessoa"
    }
}

// MARK: - PhoneResponse

struct PhoneResponse: Decodable, Equatable {
    let code: Int?
    let areaCode: Int?
    let countryCode: Int?
    let number: Int?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case code = "codigo",
             areaCode = "ddd",
             countryCode = "ddi",
             number = "numero",
             type = "tipo"
    }
}

// MARK: - AddressResponse

struct AddressResponse: Decodable, Equatable {
    let streetType: String?
    let street: String?
    let number: String?
    let complement: String?
    let zipCode: String?
    let additionalZipCode: String?
    let neighborhood: String?
    let city: String?
    let state: String?
    let country: String?
    let latitude: String?
    let longitude: String?
    let purposeCode: Int?
    let purposeDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case streetType = "tipoLogradouro"
        case street = "logradouro"
        case number = "numero"
        case complement = "complemento"
        case zipCode = "cep"
        case additionalZipCode = "cplcepnum"
        case neighborhood = "bairro"
        case city = "cidade"
        case state = "uf"
        case country = "pais"
        case latitude
        case longitude
        case purposeCode = "codigoFinalidade"
        case purposeDescription = "descricaoFinalidade"
    }
}

// MARK: - DeviceDataResponse

struct DeviceDataResponse: Codable, Equatable {
    let deviceCode: Int?
    let deviceTypeCode: Int?
    let relevanceCode: Int?
    let phoneBrand: String?
    let phoneBrandCode: Int?
    let phoneModel: String?
    let phoneModelCode: Int?
    let phoneCapacity: String?
    let phoneAge: Int?
    let marketValue: String?
    
    enum CodingKeys: String, CodingKey {
        case deviceCode,
             deviceTypeCode,
             relevanceCode,
             phoneBrand,
             phoneBrandCode,
             phoneModel,
             phoneModelCode,
             phoneCapacity,
             phoneAge,
             marketValue
    }
}

// MARK: - CardResponse

struct CardResponse: Decodable, Equatable {
    let lastDigits: String?
    let flag: String?
    let cardId: String?
    
    enum CodingKeys: String, CodingKey {
        case lastDigits,
             flag,
             cardId
    }
}
