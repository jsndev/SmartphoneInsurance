//
//  NoGeoLocationWarningViewModel.swift
//  Smartphone
//
//  Created by Stefan Vargas on 29/09/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Components
import Core
import DesignSystem
import Foundation

struct NoGeoLocationWarningViewModel: NoGeoLocationWarningViewModelProtocol {
    
    // MARK: - Properties

    var backGroundColor: UIColor
    var title: Dynamic<String>
    var icon: Icons
    var arrow: Dynamic<Icons>
    var action: GenericAction?

    // MARK: - Initializer

    init(color: UIColor, title: String, icon: Icons, arrow: Icons) {
        self.backGroundColor = color
        self.title = Dynamic<String>(title)
        self.icon = icon
        self.arrow = Dynamic<Icons>(arrow)
    }
    
    // MARK: - Instantiate
    static func createDefaultModel() -> NoGeoLocationWarningViewModel {
        let noLocationText = LocalizableBundle.smartphoneNeedYourLocaton.localize
        
        return NoGeoLocationWarningViewModel(color: .brandColorPrimary, title: noLocationText, icon: .location, arrow: .rightArrow)
    }
    
    // MARK: - Other Methods
    mutating func insert(action: @escaping GenericAction) {
        self.action = action
    }
}
