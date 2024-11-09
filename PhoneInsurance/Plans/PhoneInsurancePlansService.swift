import Core
import Foundation
import RequestKit

protocol PhoneInsurancePlansServicing {}

final class PhoneInsurancePlansService: BaseManager {
    private let provider: ApiProviderProtocol?

    required init(provider: ApiProviderProtocol? = nil) {
        self.provider = provider
    }
    
    public convenience init() {
        self.init(provider: nil)
    }
}

extension PhoneInsurancePlansService: PhoneInsurancePlansServicing {}
