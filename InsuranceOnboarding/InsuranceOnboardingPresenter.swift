//
//  InsuranceOnboardingPresenter.swift
//  Smartphone
//
//  Created by Dennis Torres on 02/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

import Foundation

protocol InsuranceOnboardingPresenting: AnyObject {
    var viewController: InsuranceOnboardingDisplaying? { get set }
    
    func presentComponents(with data: BenefitsResponse)
    func presentLoading()
    func presentInternal(couponDiscount: String?)
    func presentURL(url: String?)
    func presentButtonAction(shouldDirectTo flow: InsuranceOnboardingFlow)
    func dismissFlow()
}

final class InsuranceOnboardingPresenter {
    weak var viewController: InsuranceOnboardingDisplaying?
    private let coordinator: InsuranceOnboardingCoordinating

    init(coordinator: InsuranceOnboardingCoordinating) {
        self.coordinator = coordinator
    }
}

extension InsuranceOnboardingPresenter: InsuranceOnboardingPresenting {
    func presentComponents(with data: BenefitsResponse) {
        viewController?.displayComponents(data: data)
    }
    
    func presentLoading() {
        viewController?.displayLoading()
    }
    
    func presentInternal(couponDiscount: String?) {
        coordinator.perform(action: .internal(couponDiscount: couponDiscount))
    }
    
    func presentURL(url: String?) {
        coordinator.perform(action: .openURL(url: url))
    }
    
    func presentButtonAction(shouldDirectTo flow: InsuranceOnboardingFlow) {
        viewController?.setupActions(shouldDirectTo: flow)
    }
    
    func dismissFlow() {
        coordinator.perform(action: .back)
    }
}
