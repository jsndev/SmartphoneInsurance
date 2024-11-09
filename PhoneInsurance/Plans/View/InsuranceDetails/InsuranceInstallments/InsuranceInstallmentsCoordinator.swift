import UIKit

enum InsuranceInstallmentsAction {
    case back
}

protocol InsuranceInstallmentsCoordinating: AnyObject {
    var viewController: UIViewController? { get set }

    func perform(action: InsuranceInstallmentsAction)
}

final class InsuranceInstallmentsCoordinator {
    weak var viewController: UIViewController?
}

extension InsuranceInstallmentsCoordinator: InsuranceInstallmentsCoordinating {
    func perform(action: InsuranceInstallmentsAction) {
        switch action {
        case .back:
            viewController?.navigationController?.popViewController(animated: true)
        }
    }
}
