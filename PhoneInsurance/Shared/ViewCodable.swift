//
//  ViewCodable.swift
//  Smartphone
//
//  Created by Jefferson Fernandes on 30/10/24.
//  E-mail jeffersonf@ciandt.com
//

import Foundation

public protocol ViewCodable: AnyObject {
    func buildViewHierarchy()
    func buildViewConstraints()
    func additionalConfig()
    func buildViewLayout()
}

public extension ViewCodable {
    func buildViewLayout() {
        buildViewHierarchy()
        buildViewConstraints()
        additionalConfig()
    }

    func additionalConfig() {
        /* Intentionally unimplemented */
    }
}
