//
//  NoGeoLocationWarningViewModelProtocol.swift
//  Smartphone
//
//  Created by Stefan Vargas on 29/09/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import CloudKit
import Components
import Core
import DesignSystem
import UIKit

protocol NoGeoLocationWarningViewModelProtocol: BaseViewModel {
    
    var backGroundColor: UIColor { get set }
    var title: Dynamic<String> { get set }
    var icon: Icons { get }
    var arrow: Dynamic<Icons> { get set }
    var action: GenericAction? { get set }
    
    init(color: UIColor, title: String, icon: Icons, arrow: Icons)
}
