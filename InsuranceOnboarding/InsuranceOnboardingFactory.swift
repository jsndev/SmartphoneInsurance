//
//  InsuranceOnboardingFactory.swift
//  Smartphone
//
//  Created by Dennis Torres on 02/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

enum InsuranceOnboardingFactory {
    static func make(coupon: String? = nil) -> InsuranceOnboardingViewController {
        let service: InsuranceOnboardingServicing = InsuranceOnboardingService()
        let coordinator: InsuranceOnboardingCoordinating = InsuranceOnboardingCoordinator()
        let presenter: InsuranceOnboardingPresenting = InsuranceOnboardingPresenter(coordinator: coordinator)
        let interactor = InsuranceOnboardingInteractor(service: service, presenter: presenter)
        let viewController = InsuranceOnboardingViewController(interactor: interactor)

        coordinator.viewController = viewController
        presenter.viewController = viewController
        
        interactor.couponDiscount = coupon

        return viewController
    }
}
