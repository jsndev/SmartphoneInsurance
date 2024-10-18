//
//  SmartphoneInsuranceCrossSellOffersViewModelProtocol.swift
//  Smartphone
//
//  Created by MARCOS VINICIUS DOS SANTOS FERREIRA on 31/05/22.
//  Copyright © 2022 Porto Seguro. All rights reserved.
//

import Foundation

protocol SmartphoneInsuranceCrossSellOffersViewModelProtocol: AnyObject {
    var headerTitle: String { get }
    var description: String { get }
    var promotionalTitle: String { get }
    var promotionalDescription: String { get }
    var buttonTitle: String { get }
    var quoteURL: String { get }
    
    init(headerTitle: String, description: String, promotionalTitle: String, promotionalDescription: String, buttonTitle: String, quoteURL: String)
}
