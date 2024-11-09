//
//  PhoneInsuranceLoadingInteractor.swift
//  Smartphone
//
//  Created by Dennis Torres on 02/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

import Foundation
import UserSecurity
import Reachability

// MARK: - Protocols

protocol PhoneInsuranceLoadingInteracting: AnyObject {
    func prepare()
}

// MARK: - Interactor

final class PhoneInsuranceLoadingInteractor {
    
    // MARK: - Properties
    
    private let timeout: Float = 30
    
    private let context = PhoneInsuranceContext.shared
    private let coreHelper = SmartphoneCoreHelper.shared
    
    private let progressData: LoadingProgressResponse?
    private let service: PhoneInsuranceLoadingServicing
    private let presenter: PhoneInsuranceLoadingPresenting
    
    private var progressBarTimer: Timer?
    private var errorAttempts: Int = .zero
    
    // MARK: - Initialization
    
    init(service: PhoneInsuranceLoadingServicing,
         presenter: PhoneInsuranceLoadingPresenting
    ) {
        self.service = service
        self.presenter = presenter
        progressData = context.get(\.progressData)
    }
}

// MARK: - PhoneInsuranceLoadingInteracting

extension PhoneInsuranceLoadingInteractor: PhoneInsuranceLoadingInteracting {
    
    // MARK: - Methods
    
    func prepare() {
        startComponentsAnimation()
        
        guard Reachability.isConnected else {
            handleError(as: .noConnection)
            return
        }
        
        if errorAttempts == 3 {
            errorAttempts = .zero
        }
        
        let personData = context.get(\.personData)
        let client = PhoneInsuranceClientRequest(
            cpf: coreHelper.get(\.userCpf),
            name: personData?.name,
            socialName: nil,
            cellPhone: "\(personData?.phone?.number)",
            email: personData?.email,
            zipCode: personData?.address?.zipCode
        )
        let request = InternalRequest(
            client: client,
            deviceData: context.get(\.deviceData),
            sessionId: coreHelper.get(\.sessionId),
            ipAddress: coreHelper.get(\.ipAddress),
            coupon: context.get(\.coupon)
        )
        
        service.fetchData(request: request, timeout: Double(timeout)) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response, let httpStatus):
                self.context.set(\.internalData, to: response)
                self.finishLoadingProgressBar()
                self.presenter.presentInternalScreen()
            case .failure(let error):
                self.stopTimer()
                self.errorAttempts += 1
                self.handleError(as: .badRequest)
            }
        }
    }
}

// MARK: - Private methods

extension PhoneInsuranceLoadingInteractor {
    private func startComponentsAnimation() {
        guard let progressData else { return }
        
        presenter.presentComponents(with: progressData, loadingTime: timeout)
        startLoadingProgressBar()
        presenter.presentFadeInTransitionCard()
    }
    
    private func startLoadingProgressBar() {
        guard let progressData else { return }
        
        var currentValue: Float = .zero
        let originalProgressTextsCount = progressData.progress?.count ?? .zero
        let progressTextsCount = max(originalProgressTextsCount - 1, .zero)
        let messageDisplayInterval = timeout / Float(progressTextsCount > .zero ? progressTextsCount : 1)
        
        let interval: TimeInterval = 0.1
        let totalUpdates: Int = Int(timeout / Float(interval))
        let updateInterval = timeout / Float(totalUpdates)
        
        progressBarTimer = .scheduledTimer(withTimeInterval: TimeInterval(updateInterval), repeats: true) { [weak self] timer in
            guard let self = self, currentValue < self.timeout else {
                self?.finishLoadingProgressBar()
                return
            }
            
            currentValue += Float(interval)
            
            let progressTextIndex: Int = {
                return currentValue < self.timeout
                ? min(Int(currentValue / messageDisplayInterval), progressTextsCount)
                : progressTextsCount
            }()
            
            let progressText: String? = {
                guard let progress = progressData.progress,
                      !progress.isEmpty
                else {
                    return nil
                }
                return progress[progressTextIndex]
            }()
            
            self.presenter.presentCurrentLoadingTime(
                currentTime: currentValue,
                progressText: progressText
            )
        }
    }
    
    private func stopTimer() {
        progressBarTimer?.invalidate()
        progressBarTimer = nil
    }
    
    private func finishLoadingProgressBar() {
        stopTimer()
        
        presenter.presentCurrentLoadingTime(currentTime: timeout, progressText: progressData?.progress?.last)
    }
    
    private func handleError(as errorType: PhoneInsuranceErrorType) {
        presenter.presentError(self, errorType)
    }
    
    private func tryAgainFetchData() {
        presenter.dismissError()
        prepare()
    }
}

// MARK: - PhoneInsuranceErrorViewDelegate

extension PhoneInsuranceLoadingInteractor: PhoneInsuranceErrorViewDelegate {
    func dismiss() {
        presenter.dismissFlow()
    }

    func buttonAction(_ type: PhoneInsuranceErrorType) {
        switch type {
        case .noConnection:
            presenter.dismissFlow()
        case .tryAgain(let attempts):
            attempts == 3
            ? presenter.presentURL(url: LocalizableBundle.smartphoneInsuranceUrlHUB.localize)
            : tryAgainFetchData()
        case .badRequest:
            presenter.presentURL(url: LocalizableBundle.smartphoneInsuranceUrlHUB.localize)
        }
    }
}
