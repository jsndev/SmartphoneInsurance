//
//  SmartphoneInsuranceCrossSellOffersViewModel.swift
//  Smartphone
//
//  Created by MARCOS VINICIUS DOS SANTOS FERREIRA on 31/05/22.
//  Copyright © 2022 Porto Seguro. All rights reserved.
//

import Foundation
import MapKit

class SmartphoneInsuranceCrossSellOffersViewModel: SmartphoneInsuranceCrossSellOffersViewModelProtocol {
    var headerTitle: String
    var description: String
    var promotionalTitle: String
    var promotionalDescription: String
    var buttonTitle: String
    var quoteURL: String
    
    required init(headerTitle: String, description: String, promotionalTitle: String, promotionalDescription: String, buttonTitle: String, quoteURL: String) {
        self.headerTitle = headerTitle
        self.description = description
        self.promotionalTitle = promotionalTitle
        self.promotionalDescription = promotionalDescription
        self.buttonTitle = buttonTitle
        self.quoteURL = quoteURL
    }
    
    convenience init(quoteURL: String) {
        self.init(headerTitle: LocalizableBundle.crossSellHeaderTitle.localize, description: LocalizableBundle.crossSellDescription.localize, promotionalTitle: LocalizableBundle.crossSellPromotionalTitle.localize, promotionalDescription: LocalizableBundle.crossSellPromotionalDescription.localize, buttonTitle: LocalizableBundle.crossSellQuoteButtonTitle.localize, quoteURL: quoteURL)
    }
}
