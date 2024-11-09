import Foundation

protocol PhoneInsurancePlansPresenting: AnyObject {
    var viewController: PhoneInsurancePlansDisplaying? { get set }
    func presentURL(url: String?)
    func back()
    func editInstallments()
}

final class PhoneInsurancePlansPresenter {
    weak var viewController: PhoneInsurancePlansDisplaying?
    private let coordinator: PhoneInsurancePlansCoordinating

    init(coordinator: PhoneInsurancePlansCoordinating) {
        self.coordinator = coordinator
    }
}

extension PhoneInsurancePlansPresenter: PhoneInsurancePlansPresenting {
    func editInstallments() {
        coordinator.perform(action: .editInstallments)
    }
    
    func back() {
        coordinator.perform(action: .back)
    }
    
    func presentURL(url: String?) {
        coordinator.perform(action: .openURL(url: url))
    }
}
