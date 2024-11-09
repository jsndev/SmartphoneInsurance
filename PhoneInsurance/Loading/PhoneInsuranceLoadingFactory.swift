//
//  PhoneInsuranceLoadingFactory.swift
//  Smartphone
//
//  Created by Dennis Torres on 02/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

enum PhoneInsuranceLoadingFactory {
    static func make() -> PhoneInsuranceLoadingViewController {
        let service: PhoneInsuranceLoadingServicing = PhoneInsuranceLoadingService()
        let coordinator: PhoneInsuranceLoadingCoordinating = PhoneInsuranceLoadingCoordinator()
        let presenter: PhoneInsuranceLoadingPresenting = PhoneInsuranceLoadingPresenter(coordinator: coordinator)
        let interactor = PhoneInsuranceLoadingInteractor(service: service, presenter: presenter)
        let viewController = PhoneInsuranceLoadingViewController(interactor: interactor)

        coordinator.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
