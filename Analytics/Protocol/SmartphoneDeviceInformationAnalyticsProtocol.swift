//
//  SmartphoneDeviceInformationAnalyticsProtocol.swift
//  Smartphone
//
//  Created by Hugo Hernany da Silva Cabral on 12/03/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Foundation

protocol SmartphoneDeviceInformationAnalyticsProtocol {
    var manufacturer: String? { get }
    var model: String? { get }
    var messageDescription: String? { get }
    var alertMessage: String? { get }
}
