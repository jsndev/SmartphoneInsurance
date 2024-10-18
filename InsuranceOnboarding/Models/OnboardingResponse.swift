//
//  OnboardingResponse.swift
//  Smartphone
//
//  Created by Dennis Torres on 02/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

import Foundation

// MARK: - OnboardingDataResponse

struct OnboardingDataResponse: Decodable {
    let benefits: BenefitsResponse
    let personData: PersonDataResponse?
    let deviceData: DeviceDataResponse?
    let cardList: [CardResponse]?
    
    enum CodingKeys: String, CodingKey {
        case benefits, personData, deviceData, cardList = "cards"
    }
}

// MARK: - PersonDataResponse

struct PersonDataResponse: Decodable {
    let personCode: Int?
    let personType: String?
    let name: String?
    let treatmentName: String?
    let documentType: String?
    let documentOwnership: String?
    let documentNumber: String?
    let birthDate: String?
    let socialName: String?
    let motherName: String?
    let fatherName: String?
    let gender: String?
    let maritalStatus: String?
    let roleCode: String?
    let roleName: String?
    let emails: [String]?
    let phones: [PhoneResponse]?
    let addresses: [AddressResponse]?
    
    enum CodingKeys: String, CodingKey {
        case personCode = "pescod"
        case personType = "tipoPessoa"
        case name = "nome"
        case treatmentName = "nomeTratamento"
        case documentType = "tipoDocumento"
        case documentOwnership = "titularidadeDocumento"
        case documentNumber = "numDocumento"
        case birthDate = "dataNascimento"
        case socialName = "nomeSocial"
        case motherName = "nomeMae"
        case fatherName = "nomePai"
        case gender = "sexo"
        case maritalStatus = "estadoCivil"
        case roleCode = "codigoPapel"
        case roleName = "nomePapel"
        case emails
        case phones = "telefones"
        case addresses = "enderecos"
    }
}

// MARK: - PhoneResponse

struct PhoneResponse: Decodable {
    let code: Int?
    let areaCode: Int?
    let countryCode: Int?
    let number: Int?
    let sequenceNumber: Int?
    let type: String?
    
    enum CodingKeys: String, CodingKey {
        case code, areaCode = "ddd", countryCode = "ddi", number, sequenceNumber = "seqnum", type
    }
}

// MARK: - AddressResponse

struct AddressResponse: Decodable {
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
        case number
        case complement
        case zipCode = "cep"
        case additionalZipCode = "cplcepnum"
        case neighborhood = "bairro"
        case city, state = "uf", country = "pais"
        case latitude, longitude
        case purposeCode = "codigoFinalidade"
        case purposeDescription = "descricaoFinalidade"
    }
}

// MARK: - DeviceDataResponse

struct DeviceDataResponse: Decodable {
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
        case deviceCode, deviceTypeCode, relevanceCode, phoneBrand, phoneBrandCode, phoneModel, phoneModelCode, phoneCapacity, phoneAge, marketValue
    }
}

// MARK: - CardResponse

struct CardResponse: Decodable {
    let brand: String?
    let category: String?
    let categoryCode: String?
    let accountNumber: String?
    let cardNumber: String?
    let maskedCardNumber: String?
    let cardType: String?
    let lastCardDigits: String?
    let isHolder: String?
    let embossing: String?
    let cardStatus: String?
    let cardStatusDescription: String?
    let bin: String?
    let bestPurchaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case brand = "bandeira"
        case category
        case categoryCode = "codigo_categoria"
        case accountNumber = "numero_conta"
        case cardNumber = "numero_cartao"
        case maskedCardNumber = "numero_cartao_mascarado"
        case cardType = "tipo_cartao"
        case lastCardDigits = "final_cartao"
        case isHolder = "flag_titular"
        case embossing
        case cardStatus = "status_cartao"
        case cardStatusDescription = "status_cartao_descricao"
        case bin
        case bestPurchaseDate = "melhor_data_compra"
    }
}
