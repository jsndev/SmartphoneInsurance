//
//  PhoneInsurancePlansDetailsViewModel.swift
//  Smartphone
//
//  Created by Jeff on 07/11/24.
//

// MARK: - Model Definition

extension PhoneInsurancePlansDetailsView {
    struct Model {
        let title: String
        let description: String
        let phoneIcon: String
        let discountDetails: String
        var installmentFirst: String
        var installmentDetails: String
        let fullPayment: String
        
        init(planResponse: PlanResponse, device: DeviceDataResponse) {
            self.title = planResponse.title.orEmpty
            self.description = "\(device.phoneBrand.orEmpty) \(device.phoneModel.orEmpty)"
            self.phoneIcon = planResponse.icon?.cellPhoneIcon ?? ""
            self.discountDetails = planResponse.appliedDiscountDescription.orEmpty
            
            let initialInstallment = InstallmentType.twelve.rawValue
            self.installmentFirst = Self.formatInstallment(planResponse, numberOfInstallments: initialInstallment)
            self.installmentDetails = Self.formatInstallmentDetails(planResponse, numberOfInstallments: initialInstallment)
            self.fullPayment = Self.formatFullPayment(planResponse)
        }
        
        mutating func updateInstallments(planResponse: PlanResponse, numberOfInstallments: Int) {
            self.installmentFirst = Self.formatInstallment(planResponse, numberOfInstallments: numberOfInstallments)
            self.installmentDetails = Self.formatInstallmentDetails(planResponse, numberOfInstallments: numberOfInstallments)
        }
        
        private static func formatInstallment(_ planResponse: PlanResponse, numberOfInstallments: Int) -> String {
            return planResponse.installments?.value(for: numberOfInstallments)?.firstInstallmentValue?.asCurrency() ?? "R$ 0,00"
        }
        
        private static func formatInstallmentDetails(_ planResponse: PlanResponse, numberOfInstallments: Int) -> String {
            guard numberOfInstallments > 1, let installments = planResponse.installments?.value(for: numberOfInstallments) else {
                return ""
            }
            let remainingInstallments = numberOfInstallments - 1
            let remainingValue = installments.remainingInstallmentsValue?.asCurrency() ?? "R$ 0,00"
            return "+\(remainingInstallments)x de \(remainingValue) (sem juros)"
        }
        
        private static func formatFullPayment(_ planResponse: PlanResponse) -> String {
            return "ou \(planResponse.installments?.value(for: InstallmentType.one.rawValue)?.firstInstallmentValue?.asCurrency() ?? "R$ 0,00") à vista"
        }
    }
}

private extension Double {
    func asCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.string(from: NSNumber(value: self)) ?? "R$ 0,00"
    }
}

private extension Optional where Wrapped == String {
    var orEmpty: String { self ?? "" }
}

private extension Array where Element == InstallmentResponse {
    func value(for numberOfInstallments: Int) -> InstallmentResponse? {
        first { $0.numberOfInstallments == numberOfInstallments }
    }
}

enum InstallmentType: Int {
    case one = 1
    case twelve = 12
}
