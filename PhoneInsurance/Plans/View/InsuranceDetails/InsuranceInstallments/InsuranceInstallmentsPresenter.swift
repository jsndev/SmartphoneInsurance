import Foundation

protocol InsuranceInstallmentsPresenting: AnyObject {
    var viewController: InsuranceInstallmentsDisplaying? { get set }
    func back()
}

final class InsuranceInstallmentsPresenter {
    weak var viewController: InsuranceInstallmentsDisplaying?
    private let coordinator: InsuranceInstallmentsCoordinating

    init(coordinator: InsuranceInstallmentsCoordinating) {
        self.coordinator = coordinator
    }
}

extension InsuranceInstallmentsPresenter: InsuranceInstallmentsPresenting {
    func back() {
        coordinator.perform(action: .back)
    }
}
