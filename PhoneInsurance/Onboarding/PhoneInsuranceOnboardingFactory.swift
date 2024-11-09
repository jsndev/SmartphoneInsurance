//
//  PhoneInsuranceOnboardingFactory.swift
//  Smartphone
//
//  Created by Dennis Torres on 02/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

enum PhoneInsuranceOnboardingFactory {
    static func make(coupon: String?, deviceInfo: SmartphoneDeviceInformationProtocol?) -> PhoneInsuranceOnboardingViewController {
        let service: PhoneInsuranceOnboardingServicing = PhoneInsuranceOnboardingService()
        let coordinator = PhoneInsuranceOnboardingCoordinator(coupon: coupon, deviceInfo: deviceInfo)
        let presenter = PhoneInsuranceOnboardingPresenter(coordinator: coordinator)
        let interactor = PhoneInsuranceOnboardingInteractor(service: service, presenter: presenter)
        let viewController = PhoneInsuranceOnboardingViewController(interactor: interactor)

        coordinator.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}

