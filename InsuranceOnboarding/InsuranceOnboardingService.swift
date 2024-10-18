//
//  InsuranceOnboardingService.swift
//  Smartphone
//
//  Created by Dennis Torres on 02/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

import Core
import Foundation
import RequestKit

typealias FetchSmartphoneInsuranceOnboardingCompletion = (Result<OnboardingDataResponse, RequestError>) -> Void

protocol InsuranceOnboardingServicing {
    func fetchOnboarding(requestParam: OnboardingParameters, completion: @escaping FetchSmartphoneInsuranceOnboardingCompletion)
}

final class InsuranceOnboardingService: BaseManager {
    private let provider: ApiProviderProtocol?
    
    required init(provider: ApiProviderProtocol? = nil) {
        self.provider = provider
    }
    
    public convenience init() {
        self.init(provider: nil)
    }
}

extension InsuranceOnboardingService: InsuranceOnboardingServicing {
    /*
     GET - /engajamento/v1/seguro-celular/beneficios
     – header Authorization: “Bearer token” *
     – header User-Agent: “Porto hml/2.2.0-hml (Android 29_10; aarch64) Xiaomi/MI 9 4.9.3 Dalvik/2.1” *
     – requestParam: descricaoModeloouMarca* ??
     
     – requestParam: nomeModeloDescricaoReferencia* ??
     
     – requestParam: capacidade*
     
     – requestParam: cupomDesconto
     */
    
    func fetchOnboarding(requestParam: OnboardingParameters, completion: @escaping FetchSmartphoneInsuranceOnboardingCompletion) {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//            completion(.success(Mock.responseOK200))
//        }
        
        let operation = RequestOperation(
            with: provider,
            andEndpoint: ApplicationConstants.PathAPI().smartphoneInsurance,
            andParameters: requestParam
        ) { result in
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        addOperation(operation)
    }
}

struct Mock {
    static let responseOK200 = OnboardingDataResponse(
        benefits: BenefitsResponse(
            mainTitle: "Seu celular merece [b]esse cuidado[/b]",
            cellPhoneBenefits: successCellPhoneBenefits,
            buttonData: successButtonData,
            loadingComponents: successLoadingCellPhoneBenefits,
            progressDescription: successProgressDescription
        ),
        personData: successPersonData,
        deviceData: successDeviceData,
        cardList: successCardList
    )
    
    static let responsePartialContent206 = OnboardingDataResponse(
        benefits: BenefitsResponse(
            mainTitle: "Seu celular merece [i]esse cuidado[/i]",
            cellPhoneBenefits: successCellPhoneBenefits,
            buttonData: successButtonData,
            loadingComponents: successLoadingCellPhoneBenefits,
            progressDescription: successProgressDescription
        ),
        personData: nil,
        deviceData: nil,
        cardList: nil
    )
    
//    let responseBadRequest400 = RequestError(
//        code: RequestErrorCode.emptyData,
//        message: "Ocorreu um erro!",
//        messages: []
//    )
    
    
    // Datas
    
    static let successButtonData = ButtonInfoResponse(
        title: "Continuar",
        evLabel: "seguro-celular-superapp"
    )
    
    static let successProgressDescription = [
        ProgressDescriptionResponse(
            value: "Verificando o melhor plano..."
        ),
        ProgressDescriptionResponse(
            value: "Aguarde um instante..."
        ),
        ProgressDescriptionResponse(
            value: "Tudo pronto!"
        )
    ]
    
    static let successCellPhoneBenefits = [
        CellPhoneBenefitsResponse(
            icon: "eb1c",
            title: "Indenização em dinheiro",
            description: "Em caso de sinistro, indenizamos em dinheiro. É mais liberdade pra escolher o aparelho que quiser."
        ),
        CellPhoneBenefitsResponse(
            icon: "eb3a",
            title: "Proteção imediata",
            description: "Sem carência. Seu celular protegido no mesmo dia da contratação."
        ),
        CellPhoneBenefitsResponse(
            icon: "eb03",
            title: "Pagamento no Cartão Porto Bank",
            description: "Parcele em até 12x sem juros para pessoa física utilizando o seu cartão de crédito Porto Bank. Cancele quando quiser, sem multa."
        ),
        CellPhoneBenefitsResponse(
            icon: "eb20",
            title: "PortoPlus",
            description: "Programa de benefícios que te dá acesso a descontos em produtos e serviços de diversas categorias."
        )
    ]
    
    static let successLoadingCellPhoneBenefits = [
        CellPhoneBenefitsResponse(
            icon: "eb34",
            title: "Sem período de carência",
            description: " A carência é o tempo que você espera para começar a usar o seguro. Ou seja, com a Porto, após receber a apólice o seu celular já estrá protegido."
        ),
        CellPhoneBenefitsResponse(
            icon: "ec1c",
            title: "Área de cobertura ",
            description: "Viaje com tranquilidade, sinistros fora do Brasil estão cobertos."
        ),
        CellPhoneBenefitsResponse(
            icon: "ebfc",
            title: "Tranquilidade para viajar",
            description: "Sinistros fora do Brasil também estão cobertos."
        )
    ]
    
    static let successPersonData = PersonDataResponse(
        personCode: 83171300,
        personType: "F",
        name: "Veruschka de Sales Azevedo",
        treatmentName: "Veruschka",
        documentType: "CPF",
        documentOwnership: "TITULAR",
        documentNumber: "05493565099",
        birthDate: "16-10-1973",
        socialName: nil,
        motherName: nil,
        fatherName: nil,
        gender: "F",
        maritalStatus: nil,
        roleCode: "1",
        roleName: "CLIENTE",
        emails: [],
        phones: [
            PhoneResponse(
                code: 1,
                areaCode: 11,
                countryCode: 55,
                number: 24845236,
                sequenceNumber: 1,
                type: "RESIDENCIA"
            )
        ],
        addresses: [
            AddressResponse(
                streetType: "Avenida",
                street: "Santana do Mundau",
                number: "493",
                complement: "Não Informado",
                zipCode: "07242190",
                additionalZipCode: "190",
                neighborhood: "Cidade Parque Alvorada",
                city: "Guarulhos",
                state: "SP",
                country: "BRA",
                latitude: "-23.44276116",
                longitude: "-46.42093712",
                purposeCode: 1,
                purposeDescription: nil
            )
        ]
    )
    
    static let successDeviceData = DeviceDataResponse(
        deviceCode: 646,
        deviceTypeCode: 35,
        relevanceCode: 1,
        phoneBrand: "iPhone",
        phoneBrandCode: 94,
        phoneModel: "iPhone XR Vermelho",
        phoneModelCode: 2222,
        phoneCapacity: "64GB",
        phoneAge: 1,
        marketValue: "2699.10"
    )
    
    static let successCardList = [
        CardResponse(
            brand: "MASTER",
            category: "Platinum",
            categoryCode: "203",
            accountNumber: "8g/UnvmLhkHPpbEjT+nioWcEmUSTU7qOaZN/OapUrOU=",
            cardNumber: "i7BKqJ56HVbzCx9uNkU78+X1CcL64SXvHLbVT3twCRE=",
            maskedCardNumber: "5329 30** **** 4117",
            cardType: "50",
            lastCardDigits: "4117",
            isHolder: "S",
            embossing: "Larry Kling",
            cardStatus: "0",
            cardStatusDescription: "DESBLOQUEADO",
            bin: "532930",
            bestPurchaseDate: "13/10"
        ),
        CardResponse(
            brand: "VISA",
            category: "Gold",
            categoryCode: "002",
            accountNumber: "KaWUIrxaDArANo9KypRGGn5Nu+10aXilxmiuwWsaZdE=",
            cardNumber: "lFfYF5QDkEYb7lP7HZxDcj2sLtsBCWHRWyd9ZTQyGFQ=",
            maskedCardNumber: "4152 74** **** 2111",
            cardType: "50",
            lastCardDigits: "2111",
            isHolder: "S",
            embossing: "Larry Kling",
            cardStatus: "3",
            cardStatusDescription: "DESBLOQUEADO",
            bin: "415274",
            bestPurchaseDate: "19/10"
        )
    ]
}
