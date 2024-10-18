//
//  SmartphoneInsuranceHeaderViewModel.swift
//  Smartphone
//
//  Created by Hugo Hernany da Silva Cabral on 22/03/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Components
import Core
import DesignSystem

class SmartphoneInsuranceHeaderViewModel: SmartphoneInsuranceHeaderViewModelProtocol, BaseViewModel {
    // MARK: - Model

    struct InsuranceDataModel {
        let insurancePolicyNumber: String?
        let insurancePolicyHolder: String?
    }

    // MARK: - Constants

    private let inspectionHeaderIconHeightSize: CGFloat = 24
    private let inspectionHeaderIconWidthSize: CGFloat = 24
    private let insuranceHeaderIconHeightSize: CGFloat = 16
    private let insuranceHeaderIconWidthSize: CGFloat = 16

    private let headerLogoiOS: String = "apple_logo"
    private let headerLogoAndroid: String = "android_logo"
    private let inspectionData: InspectionDataModel?
    private let insuranceData: SmartphoneInsuranceData?
    private let proposeFormat: String = "Proposta: %@"

    // MARK: - Properties

    var headerViewModel: HeaderViewModelProtocol?
    var isExpanded = Dynamic<Bool?>(false)
    var status: InspectionStatus?

    // MARK: - Initializers

    init(with inspection: InspectionDataModel?, insuranceData: SmartphoneInsuranceData?, isExpanded: Bool) {
        inspectionData = inspection
        self.isExpanded.value = isExpanded
        status = inspection?.inspectionStatus
        self.insuranceData = insuranceData
        setInspectionHeaderViewModel(with: inspection, isExpanded: isExpanded)
        setInsuranceHeaderViewModel(with: insuranceData, isExpanded: isExpanded)
    }

    // MARK: - Public Methods

    func updateHeaderStatus(isExpanded: Bool, type: SmartphoneContentType) {
        self.isExpanded.value = isExpanded
        headerViewModel?.setIcon(isExpanded: isExpanded)
        headerViewModel?.setBackgroundColor(isExpanded: isExpanded)
        headerViewModel?.setStatusViewHidden(isExpanded: isExpanded)
        var accessibilityLabel = String()

        switch type {
        case .inspection:
            guard let inspection = inspectionData else { return }
            let statusLabel = headerViewModel?.status.value?.rawValue ?? ""
            accessibilityLabel = setAcessibilityInspectionHeaderText(with: inspection, statusLabel: statusLabel)
        case .insurance:
            guard let insurance = insuranceData else { return }
            accessibilityLabel = setAcessibilityInsuranceHeaderText(with: insurance)
        }

        var headerViewModelTraits: UIAccessibilityTraits = .button

        if isExpanded {
            headerViewModelTraits.insert(.selected)
        } else {
            headerViewModelTraits.remove(.selected)
        }

        headerViewModel?.setAccessibility(AccessibilityViewModel(label: accessibilityLabel, traits: headerViewModelTraits))
    }

    // MARK: - Private Functions

    private func setInsuranceHeaderViewModel(with insurance: SmartphoneInsuranceData?, isExpanded: Bool) {
        guard let insurance = insurance, let insurancePolicyNumber = insurance.insurancePolicy else { return }
        var viewModel = HeaderViewModel(iconExpanded: .hide, iconCollapsed: .expand, backgroundExpanded: .clear, backgroundCollapsed: .brandSupport05, cardState: .unblock)
        viewModel.cardTitle.value = String(format: LocalizableBundle.smartphoneInsurancePolicyNumber.localize, insurancePolicyNumber)
        viewModel.cardSubtitle.value = insurance.insuranceHolder ?? String()
        viewModel.setIcon(isExpanded: isExpanded)
        viewModel.setBackgroundColor(isExpanded: isExpanded)

        viewModel.flag.value = Icons.receipt.toImage(withSize: Size.small.rawValue, color: .brandColorSecondary)
        viewModel.flagHeight.value = insuranceHeaderIconHeightSize
        viewModel.flagWidth.value = insuranceHeaderIconWidthSize
        viewModel.setAccessibility(AccessibilityViewModel(label: setAcessibilityInsuranceHeaderText(with: insurance), traits: .button))

        headerViewModel = viewModel
    }

    private func setInspectionHeaderViewModel(with inspection: InspectionDataModel?, isExpanded: Bool) {
        guard let inspection = inspection else { return }
        var viewModel = HeaderViewModel(iconExpanded: .hide,
                                        iconCollapsed: .expand,
                                        backgroundExpanded: .clear,
                                        backgroundCollapsed: .brandSupport05,
                                        cardState: .unblock,
                                        iconAction: nil)
        viewModel.cardTitle.value = inspection.inspectionItems?.first?.inspectionEquipment?.comercialModel
        viewModel.cardSubtitle.value = String(format: proposeFormat, String(inspection.proposeNumber ?? .zero))
        viewModel.setIcon(isExpanded: isExpanded)
        viewModel.setBackgroundColor(isExpanded: isExpanded)
        viewModel.flag.value = UIImage(named: getPlatformLogo(platform: inspection.inspectionItems?.first?.inspectionEquipment?.equipmentBrandName), in: Components().getBundle, compatibleWith: nil) ?? UIImage()
        viewModel.flagHeight.value = inspectionHeaderIconHeightSize
        viewModel.flagWidth.value = inspectionHeaderIconWidthSize

        switch inspection.inspectionStatus {
        case .pending:
            viewModel.status.value = .pending
        case .declinedPropose, .refused, .refusedImei, .refusedModel, .refusedStorage, .declinedProposePayment, .declinedDisplay, .declinedTouch:
            viewModel.status.value = .reproved
        default:
            viewModel.status.value = nil
        }
        
        let statusLabel = viewModel.status.value?.rawValue ?? ""
        viewModel.setAccessibility(AccessibilityViewModel(label: setAcessibilityInspectionHeaderText(with: inspection, statusLabel: statusLabel), traits: .button))
        viewModel.isStatusViewHidden.value = isExpanded

        headerViewModel = viewModel
    }

    private func getPlatformLogo(platform: String?) -> String {
        guard let platform = platform?.normalizeValue else { return "" }
        let platformLogo = platform == "apple" ? headerLogoiOS : headerLogoAndroid
        return platformLogo
    }

    private func setAcessibilityInspectionHeaderText(with inspection: InspectionDataModel, statusLabel: String) -> String {
        let deviceModel = inspection.inspectionItems?.first?.inspectionEquipment?.comercialModel ?? ""
        let proposeNumber = String(format: "Proposta %@", String(inspection.proposeNumber ?? .zero)) 
        var accessibilityLabel = String(format: AccessibilityLocalizableBundle.smartphoneHeader.accessibilityLocalize, deviceModel, proposeNumber)
        if !statusLabel.isEmpty {
            let statusLabel = String(format: AccessibilityLocalizableBundle.smartphoneHeaderDeviceStatus.accessibilityLocalize, statusLabel)
            accessibilityLabel = String(format: "%@ %@", accessibilityLabel, statusLabel)
        }
        if let isExpanded = isExpanded.value, isExpanded {
            return String(format: "%@ %@", accessibilityLabel, AccessibilityLocalizableBundle.smartphoneHeaderMoreInformations.accessibilityLocalize)
        }
        return accessibilityLabel
    }

    private func setAcessibilityInsuranceHeaderText(with insurance: SmartphoneInsuranceData) -> String {
        let accessibilityLabel = String(format: AccessibilityLocalizableBundle.smartphoneInsurancePolicyNumber.accessibilityLocalize, insurance.insurancePolicy ?? String(), insurance.insuranceHolder ?? String())
        if let isExpanded = isExpanded.value, isExpanded {
            return String(format: "%@ %@", accessibilityLabel, AccessibilityLocalizableBundle.smartphoneHeaderMoreInformations.accessibilityLocalize)
        }
        return accessibilityLabel
    }
}
