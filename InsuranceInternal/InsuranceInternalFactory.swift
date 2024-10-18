//
//  InsuranceInternalFactory.swift
//  Smartphone
//
//  Created by Dennis Torres on 02/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

enum InsuranceInternalFactory {
    static func make() -> InsuranceInternalViewController {
        let service: InsuranceInternalServicing = InsuranceInternalService()
        let coordinator: InsuranceInternalCoordinating = InsuranceInternalCoordinator()
        let presenter: InsuranceInternalPresenting = InsuranceInternalPresenter(coordinator: coordinator)
        let interactor = InsuranceInternalInteractor(service: service, presenter: presenter)
        let viewController = InsuranceInternalViewController(interactor: interactor)

        coordinator.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
