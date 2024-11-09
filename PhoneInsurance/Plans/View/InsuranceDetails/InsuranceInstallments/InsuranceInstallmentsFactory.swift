enum InsuranceInstallmentsFactory {
    static func make() -> InsuranceInstallmentsViewController {
        let coordinator: InsuranceInstallmentsCoordinating = InsuranceInstallmentsCoordinator()
        let presenter: InsuranceInstallmentsPresenting = InsuranceInstallmentsPresenter(coordinator: coordinator)
        let interactor = InsuranceInstallmentsInteractor(presenter: presenter)
        let viewController = InsuranceInstallmentsViewController(interactor: interactor)

        coordinator.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
