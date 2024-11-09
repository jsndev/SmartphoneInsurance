import Foundation

protocol InsuranceInstallmentsInteracting: AnyObject {
    func back()
}

final class InsuranceInstallmentsInteractor {
    private let presenter: InsuranceInstallmentsPresenting

    init(presenter: InsuranceInstallmentsPresenting) {
        self.presenter = presenter
    }
}

extension InsuranceInstallmentsInteractor: InsuranceInstallmentsInteracting {
    func back() {
        presenter.back()
    }
}
