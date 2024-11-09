// MARK: - Factory

enum PhoneInsurancePlansFactory {
    static func make() -> PhoneInsurancePlansViewController {
        let service: PhoneInsurancePlansServicing = PhoneInsurancePlansService()
        let coordinator: PhoneInsurancePlansCoordinating = PhoneInsurancePlansCoordinator()
        let presenter: PhoneInsurancePlansPresenting = PhoneInsurancePlansPresenter(coordinator: coordinator)
        let interactor = PhoneInsurancePlansInteractor(service: service, presenter: presenter)
        let viewProvider = PhoneInsurancePlansViewProvider()
        let viewController = PhoneInsurancePlansViewController(interactor: interactor, viewProvider: viewProvider)

        coordinator.viewController = viewController
        presenter.viewController = viewController

        return viewController
    }
}
