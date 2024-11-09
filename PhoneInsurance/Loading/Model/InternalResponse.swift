//
//  InternalResponse.swift
//  Smartphone
//
//  Created by Dennis Torres on 06/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

// MARK: - InternalResponse

struct InternalResponse: Decodable, Equatable {
    let plan: PlanResponse?

    enum CodingKeys: String, CodingKey {
        case plan = "plano"
    }
}

// MARK: - PlanResponse

struct PlanResponse: Decodable, Equatable {
    let title: String?
    let icon: IconResponse?
    let appliedDiscountDescription: String?
    let installments: [InstallmentResponse]?
    let advantages: AdvantagesResponse?
    let coverages: AdvantagesResponse?
    let learnMore: LearnMoreResponse?
    let generalConditions: GeneralConditionsResponse?
    let incomeBracket: IncomeBracketResponse?

    enum CodingKeys: String, CodingKey {
        case title = "titulo"
        case icon
        case appliedDiscountDescription = "descricaoDescontoAplicado"
        case installments = "parcelamentos"
        case advantages = "vantagens"
        case coverages = "coberturas"
        case learnMore = "saibaMais"
        case generalConditions = "condicoesGerais"
        case incomeBracket = "faixaDeRenda"
    }
}

// MARK: - IconResponse

struct IconResponse: Decodable, Equatable {
    let cellPhoneIcon: String?
    let editIcon: String?

    enum CodingKeys: String, CodingKey {
        case cellPhoneIcon = "iconeCelular"
        case editIcon = "iconeEditar"
    }
}

// MARK: - InstallmentResponse

struct InstallmentResponse: Decodable, Equatable {
    let paymentPlanCode: String?
    let paymentMethodName: String?
    let numberOfInstallments: Int?
    let firstInstallmentValue: Double?
    let remainingInstallmentsValue: Double?
    let charges: Double?
    let iof: Double?
    let interest: Double?
    let valueWithoutIOF: Double?

    enum CodingKeys: String, CodingKey {
        case paymentPlanCode = "codigoPlanoParcelamentoSistemaPagamento"
        case paymentMethodName = "nomeFormaPagamento"
        case numberOfInstallments = "quantidadeParcela"
        case firstInstallmentValue = "valorPrimeiraParcela"
        case remainingInstallmentsValue = "valorDemaisParcelas"
        case charges = "encargos"
        case iof
        case interest = "juros"
        case valueWithoutIOF = "valorSemIOF"
    }
}

// MARK: - AdvantagesResponse

struct AdvantagesResponse: Decodable, Equatable {
    let title: String?
    let icon: String?
    let items: [ItemResponse]?
    let details: DetailsResponse?

    enum CodingKeys: String, CodingKey {
        case title = "titulo"
        case icon = "icone"
        case items = "itens"
        case details = "detalhes"
    }
}

// MARK: - ItemResponse

struct ItemResponse: Decodable, Equatable {
    let icon: String?
    let text: String?

    enum CodingKeys: String, CodingKey {
        case icon = "icone"
        case text = "texto"
    }
}

// MARK: - DetailsResponse

struct DetailsResponse: Decodable, Equatable {
    let title: String?
    let subtitle: String?
    let items: [String]?

    enum CodingKeys: String, CodingKey {
        case title = "titulo"
        case subtitle = "subtitulo"
        case items
    }
}

// MARK: - LearnMoreResponse

struct LearnMoreResponse: Decodable, Equatable {
    let description: String?
    let hyperlink: String?
    let detail: DetailResponse?

    enum CodingKeys: String, CodingKey {
        case description = "descricao"
        case hyperlink
        case detail = "detalhe"
    }
}

// MARK: - DetailResponse

struct DetailResponse: Decodable, Equatable {
    let title: String?
    let subtitle: String?
    let items: [String]?

    enum CodingKeys: String, CodingKey {
        case title = "titulo"
        case subtitle = "subtitulo"
        case items
    }
}

// MARK: - GeneralConditionsResponse

struct GeneralConditionsResponse: Decodable, Equatable {
    let description: String?
    let hyperlink: String?
    let detail: ConditionsDetailResponse?

    enum CodingKeys: String, CodingKey {
        case description = "descricao"
        case hyperlink
        case detail = "detalhe"
    }
}

// MARK: - ConditionsDetailResponse

struct ConditionsDetailResponse: Decodable, Equatable {
    let title: String?
    let subtitle: String?
    let itemsTitle: String?
    let items: [String]?
    let link: String?

    enum CodingKeys: String, CodingKey {
        case title = "titulo"
        case subtitle = "subtitulo"
        case itemsTitle = "tituloItens"
        case items
        case link
    }
}

// MARK: - IncomeBracketResponse

struct IncomeBracketResponse: Decodable, Equatable {
    let title: String?
    let placeholder: String?
    let brackets: [BracketResponse]?

    enum CodingKeys: String, CodingKey {
        case title = "titulo"
        case placeholder
        case brackets = "faixas"
    }
}

// MARK: - BracketResponse

struct BracketResponse: Decodable, Equatable {
    let description: String?
    let code: Int?

    enum CodingKeys: String, CodingKey {
        case description = "descricao"
        case code = "codigo"
    }
}
