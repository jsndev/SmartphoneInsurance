import Foundation

protocol PhoneInsurancePlansInteracting: AnyObject {
    func openHub()
    func back()
    func editInstallments()
}

final class PhoneInsurancePlansInteractor {
    private let service: PhoneInsurancePlansServicing
    private let presenter: PhoneInsurancePlansPresenting

    init(service: PhoneInsurancePlansServicing, presenter: PhoneInsurancePlansPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

extension PhoneInsurancePlansInteractor: PhoneInsurancePlansInteracting {
    func editInstallments() {
        presenter.editInstallments()
    }
    
    func back() {
        presenter.back()
    }
    
    func openHub() {
        let urlHUB: String = LocalizableBundle.smartphoneInsuranceUrlHUB.localize
        presenter.presentURL(url: urlHUB)
    }
}
