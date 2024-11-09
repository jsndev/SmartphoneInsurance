//
//  ConfigurableView.swift
//  Smartphone
//
//  Created by Jeff on 06/11/24.
//

import Foundation

protocol ConfigurableView {
    associatedtype DataModel
    func configure(with model: DataModel)
}
