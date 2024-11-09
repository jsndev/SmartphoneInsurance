//
//  PhoneInsuranceOnboardingService.swift
//  Smartphone
//
//  Created by Dennis Torres on 02/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

import Core
import Foundation
import RequestKit

// MARK: - Typealias

typealias FetchOnboardingDataCompletion = (Result<(OnboardingDataResponse, HttpResponseStatus), RequestKit.RequestError>) -> Void

// MARK: - Protocol Definition

protocol PhoneInsuranceOnboardingServicing {
    func fetchData(request: OnboardingRequest, completion: @escaping FetchOnboardingDataCompletion)
}

// MARK: - Service Class

final class PhoneInsuranceOnboardingService: BaseManager {
    
    // MARK: - Properties
    
    private let provider: ApiProviderProtocol?

    // MARK: - Initializers
    
    required init(provider: ApiProviderProtocol? = nil) {
        self.provider = provider
    }
    
    public convenience init() {
        self.init(provider: nil)
    }
}

// MARK: - PhoneInsuranceOnboardingServicing

extension PhoneInsuranceOnboardingService: PhoneInsuranceOnboardingServicing {
    
    func fetchData(
        request: OnboardingRequest,
        completion: @escaping FetchOnboardingDataCompletion
    ) {
        let operation = RequestOperation<OnboardingDataResponse, OnboardingRequest>(
            with: provider,
            andEndpoint: Endpoint.phoneInsuranceOnboarding.url(version: .v1, domain: .engagement),
            andHttpMethod: .get,
            andParameters: request,
            andRequestType: .query,
            version: .v1,
            completion: { result in
                OperationQueue.main.addOperation {
                    completion(result)
                }
            }
        )
        
        addOperation(operation)
    }
}
