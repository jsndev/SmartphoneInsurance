//
//  PhoneInsuranceOnboardingInteractor.swift
//  Smartphone
//
//  Created by Dennis Torres on 02/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

import Foundation
import Core
import Reachability

enum PhoneInsuranceOnboardingFlow {
    case hub(urlString: String?)
    case loadingScreen
}

// MARK: - Protocols

protocol PhoneInsuranceOnboardingInteracting: AnyObject {
    func fetchOnboardingData()
    func close()
    func openInternal()
    func openURL(url: String?)
}

// MARK: - Interactor

final class PhoneInsuranceOnboardingInteractor {
    
    // MARK: - Properties

    private let service: PhoneInsuranceOnboardingServicing
    private let presenter: PhoneInsuranceOnboardingPresenting
    private let context = PhoneInsuranceContext.shared
    
    private var errorAttempts: Int = .zero

    // MARK: - Initialization

    init(service: PhoneInsuranceOnboardingServicing, presenter: PhoneInsuranceOnboardingPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

// MARK: - PhoneInsuranceOnboardingInteracting

extension PhoneInsuranceOnboardingInteractor: PhoneInsuranceOnboardingInteracting {
    
    // MARK: - Methods
    
    func fetchOnboardingData() {
        presenter.dismissError()
        presenter.presentLoading()
        
        guard Reachability.isConnected else {
            handleError(as: .noConnection)
            return
        }
        
        if errorAttempts == 3 {
            errorAttempts = .zero
        }
        
        guard let request = createOnboardingRequest() else {
            errorAttempts += 1
            handleError(as: .tryAgain(errorAttempts))
            return
        }
        
        service.fetchData(request: request) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let (response, statusCode)):
                self.handleSuccess(response: response, statusCode: statusCode, requestParam: request)
            case .failure(let error):
                self.errorAttempts += 1
                let errorType: PhoneInsuranceErrorType = error.code == .invalidData ? .badRequest : .tryAgain(self.errorAttempts)
                self.handleError(as: errorType)
            }
        }
    }

    // MARK: - Navigation Methods
    
    func close() {
        presenter.dismissFlow()
    }

    func openInternal() {
        presenter.presentLoadingScreen()
    }

    func openURL(url: String?) {
        presenter.presentURL(url: url)
    }
}

// MARK: - Private methods

extension PhoneInsuranceOnboardingInteractor {
    
    private func handleSuccess(
        response: OnboardingDataResponse,
        statusCode: HttpResponseStatus,
        requestParam: OnboardingRequest
    ) {
        presenter.presentComponents(with: response.benefits)
        assignSingletonValues(onboardingResponse: response)
        
        let flow = determineOnboardingFlow(response: response, statusCode: statusCode)
        presenter.presentButtonAction(shouldDirectTo: flow)
    }

    private func determineOnboardingFlow(
        response: OnboardingDataResponse,
        statusCode: HttpResponseStatus
    ) -> PhoneInsuranceOnboardingFlow {
        if case .partialContent = statusCode {
            let urlHUB: String = LocalizableBundle.smartphoneInsuranceUrlHUB.localize
            return .hub(urlString: urlHUB)
        } else {
            let internalLoadingModel = LoadingProgressResponse(
                benefits: response.benefits.loadingComponents,
                progress: response.benefits.progressDescriptions
            )
            return .loadingScreen
        }
    }
    
    private func createOnboardingRequest() -> OnboardingRequest? {
        guard let deviceInfo = context.get(\.deviceInfo) else { return nil }
        
        return OnboardingRequest(
            manufacturer: deviceInfo.manufacturer,
            model: deviceInfo.model,
            internalStorage: deviceInfo.internalStorage
        )
    }
    
    private func assignSingletonValues(onboardingResponse: OnboardingDataResponse) {
        context.set(\.personData, to: onboardingResponse.personData)
        context.set(\.cardList, to: onboardingResponse.cardList)
        context.set(\.deviceData, to: onboardingResponse.deviceData)
        context.set(\.progressData, to: (onboardingResponse.benefits.loadingComponents, onboardingResponse.benefits.progressDescriptions))
    }
    
    private func handleError(as errorType: PhoneInsuranceErrorType) {
        presenter.presentError(self, errorType)
    }
}

// MARK: - PhoneInsuranceErrorViewDelegate

extension PhoneInsuranceOnboardingInteractor: PhoneInsuranceErrorViewDelegate {
    func dismiss() {
        close()
    }

    func buttonAction(_ type: PhoneInsuranceErrorType) {
        switch type {
        case .noConnection:
            close()
        case .tryAgain(let attempts):
            attempts == 3
            ? openURL(url: LocalizableBundle.smartphoneInsuranceUrlHUB.localize)
            : fetchOnboardingData()
        case .badRequest:
            openURL(url: LocalizableBundle.smartphoneInsuranceUrlHUB.localize)
        }
    }
}
