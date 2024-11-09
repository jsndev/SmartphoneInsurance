//
//  PhoneInsuranceLoadingService.swift
//  Smartphone
//
//  Created by Dennis Torres on 02/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

import Core
import Foundation
import RequestKit
import UserSecurity

// MARK: - Typealias

typealias FetchInternalDataCompletion = (Result<(InternalResponse, HttpResponseStatus), RequestKit.RequestError>) -> Void

// MARK: - Protocol Definition

protocol PhoneInsuranceLoadingServicing {
    func fetchData(request: InternalRequest, timeout: Double, completion: @escaping FetchInternalDataCompletion)
}

// MARK: - Service Class

final class PhoneInsuranceLoadingService: BaseManager {
    
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

// MARK: - PhoneInsuranceLoadingServicing

extension PhoneInsuranceLoadingService: PhoneInsuranceLoadingServicing {
    func fetchData(
        request: InternalRequest,
        timeout: Double,
        completion: @escaping FetchInternalDataCompletion
    ) {
//        request.toBodyParameters().bodyParameters?.merge(with: <#T##[String : AnyObject]#>)
        let operation = RequestOperation<InternalResponse, InternalRequest>(
            with: provider,
            andEndpoint: Endpoint.phoneInsuranceInternal.url(version: .v1, domain: .engagement),
            andHttpMethod: .post,
            andParameters: request,
            andRequestType: .body,
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
