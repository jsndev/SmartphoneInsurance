//
//  SmartphoneBusiness.swift
//  Smartphone
//
//  Created by Koji Osugi on 25/06/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Core
import Insurance

public class SmartphoneBusiness: SmartphoneBusinessProtocol {
    // MARK: - Properties

    private let memoryData: MemoryDataProtocol
    private let inspectionListManager: InspectionListManagerProtocol
    private let financialDetailsManager: FinancialDetailsManagerProtocol

    // MARK: - Initializer

    public init(memoryData: MemoryDataProtocol = MemoryData.shared,
                inspectionListManager: InspectionListManagerProtocol = InspectionListManager(),
                financialDetailsManager: FinancialDetailsManagerProtocol = FinancialDetailsManager()) {
        self.memoryData = memoryData
        self.inspectionListManager = inspectionListManager
        self.financialDetailsManager = financialDetailsManager
    }

    // MARK: - Public methods

    public func fetchInspectionList(forceUpdate: Bool, insuranceList: [String]?, apiVersion: String?, completion: @escaping InspectionListCompletion) {
        let shouldFetchFromCache = FeatureToggle.isAvailable(.homeCache) && !forceUpdate
        let cacheID = CacheID.smartphoneInspectionList.rawValue

        if shouldFetchFromCache, let cachedValue: InspectionList = memoryData.getValue(key: cacheID) {
            completion(.success(cachedValue))
            return
        }

        inspectionListManager.fetchInspectionList(insuranceList: insuranceList, apiVersion: apiVersion) { [weak self] result in
            switch result {
            case .success(let inspection):
                try? self?.memoryData.save(key: cacheID, value: inspection)
                completion(.success(inspection))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public func fetchFinancialDetails(fullPolicyNumber: String, completion: @escaping (SmartphoneFinancialDetailsResult) -> Void) {
        financialDetailsManager.fetchFinancialDetails(product: .smartphone, policy: fullPolicyNumber) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                let financialDetailsError = self.handleFinancialDetailsError(error)
                completion(.failure(financialDetailsError))
            }
        }
    }

    private func handleFinancialDetailsError(_ error: Error) -> SmartphoneFinancialDetailsError {
        let isPresentableError: Bool
        let isCollectiveInvoiceError: Bool

        if case BaseError.httpError(_, let responseStatus, _) = error,
           case .unprocessableEntity = responseStatus { // 422 status code
            isPresentableError = false
        } else {
            isPresentableError = true
        }

        if case FinancialDetailsError.collectiveInvoice = error {
            isCollectiveInvoiceError = true
        } else {
            isCollectiveInvoiceError = false
        }
        return SmartphoneFinancialDetailsError(isCollectiveInvoiceError: isCollectiveInvoiceError, isPresentableError: isPresentableError)
    }
}
