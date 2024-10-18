//
//  SmartphoneBusinessProtocol.swift
//  Smartphone
//
//  Created by Koji Osugi on 25/06/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Insurance

public struct SmartphoneFinancialDetailsError {
    let isCollectiveInvoiceError: Bool
    let isPresentableError: Bool
}

public enum SmartphoneFinancialDetailsResult {
    case success(FinancialDetailsResponse)
    case failure(SmartphoneFinancialDetailsError)
}

public protocol SmartphoneBusinessProtocol {
    /// Fetches the InspectionList data
    /// - Parameters:
    ///   - forceUpdate: wheter should fetch inspection list from manager, otherwise should fetch from cache
    ///   - insuranceList: previous insurance list
    ///   - apiVersion: A string with the api version
    ///   - completion: `InspectionList` request handler
    func fetchInspectionList(forceUpdate: Bool, insuranceList: [String]?, apiVersion: String?, completion: @escaping InspectionListCompletion)

    /// Fetches the financial details data
    /// - Parameters:
    ///   - fullPolicyNumber: full policy number from insurance data
    ///   - completion: completion handler. Wheter request succeed or not
    func fetchFinancialDetails(fullPolicyNumber: String, completion: @escaping (SmartphoneFinancialDetailsResult) -> Void)
}
