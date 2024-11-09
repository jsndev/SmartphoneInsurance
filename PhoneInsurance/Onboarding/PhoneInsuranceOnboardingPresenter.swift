//
//  PhoneInsuranceOnboardingPresenter.swift
//  Smartphone
//
//  Created by Dennis Torres on 02/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

import RequestKit
import Foundation

// MARK: - Protocols

protocol PhoneInsuranceOnboardingPresenting: AnyObject {
    func presentComponents(with data: BenefitsResponse)
    func presentButtonAction(shouldDirectTo flow: PhoneInsuranceOnboardingFlow)
    func presentLoading()
    func presentError(_ delegate: PhoneInsuranceErrorViewDelegate, _ errorType: PhoneInsuranceErrorType)
    func presentLoadingScreen()
    func presentURL(url: String?)
    func dismissFlow()
    func dismissError()
}

// MARK: - Presenter

final class PhoneInsuranceOnboardingPresenter {
    // MARK: - Properties
    
    weak var viewController: PhoneInsuranceOnboardingDisplaying?
    private let coordinator: PhoneInsuranceOnboardingCoordinating
    
    // MARK: - Initialization
    
    init(coordinator: PhoneInsuranceOnboardingCoordinating) {
        self.coordinator = coordinator
    }
}

// MARK: - PhoneInsuranceOnboardingPresenting

extension PhoneInsuranceOnboardingPresenter: PhoneInsuranceOnboardingPresenting {
    // MARK: - Methods
    
    func presentLoading() {
        viewController?.displayLoading()
    }
    
    func presentComponents(with data: BenefitsResponse) {
        viewController?.displayComponents(data: data)
    }
    
    func presentButtonAction(shouldDirectTo flow: PhoneInsuranceOnboardingFlow) {
        viewController?.setupActions(shouldDirectTo: flow)
    }
    
    func presentLoadingScreen() {
        coordinator.perform(action: .loadingScreen)
    }
    
    func presentURL(url: String?) {
        coordinator.perform(action: .openURL(url: url))
    }
    
    func presentError(_ delegate: PhoneInsuranceErrorViewDelegate, _ errorType: PhoneInsuranceErrorType) {
        coordinator.performError(action: .present(delegate, errorType))
    }
    
    func dismissFlow() {
        coordinator.perform(action: .back)
    }
    
    func dismissError() {
        coordinator.performError(action: .dismiss)
    }
}
