import UIKit
import Core

enum PhoneInsurancePlansAction {
    case back
    case openURL(url: String?)
    case editInstallments
}

protocol PhoneInsurancePlansCoordinating: AnyObject {
    var viewController: UIViewController? { get set }

    func perform(action: PhoneInsurancePlansAction)
}

final class PhoneInsurancePlansCoordinator {
    weak var viewController: UIViewController?
}

extension PhoneInsurancePlansCoordinator: PhoneInsurancePlansCoordinating {
    func perform(action: PhoneInsurancePlansAction) {
        switch action {
        case .back:
            viewController?.navigationController?.popViewController(animated: true)
        case .openURL(let urlString):
            guard let urlString, let url = URL(string: urlString) else { return }
            DeepLinkHiddenModeHandler.processDeepLink(with: url)
        case .editInstallments:
            let insuranceInstallments = InsuranceInstallmentsFactory.make()
            viewController?.navigationController?.pushViewController(insuranceInstallments, animated: true)
        }
    }
}
