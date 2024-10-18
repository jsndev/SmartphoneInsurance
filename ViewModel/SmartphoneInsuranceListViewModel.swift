//
//  SmartphoneInsuranceListViewModel.swift
//  Smartphone
//
//  Created by Hugo Hernany da Silva Cabral on 10/03/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Components
import Core
import Foundation
import Insurance
import UserSecurity

public class SmartphoneInsuranceListViewModel: SmartphoneInsuranceListViewModelProtocol {
    // MARK: - Constants

    private let singleDay: Int = 1
    private var delayTimeToAsyncAnimation: DispatchTime {
        DispatchTime.now() + 0.05
    }

    // MARK: - Dynamic Properties

    public var productUnavailableCompletion: ProductUnavailableCompletion?
    public var viewState = Dynamic<SmartphoneInsuranceListViewState>(.loading)
    public var sectionModels = Dynamic<[ExpandableTableViewCellModelProtocol]>([])
    public var smartphoneInsuranceData: [SmartphoneInsuranceData]?
    public var hasSmartphoneProduct: Bool
    
    // MARK: - Private Properties

    private var attemptsCount: Int = .zero
    private var isReloading = false

    // MARK: - Private Constants

    private let smartphoneBusiness: SmartphoneBusinessProtocol
    private let openValidationAction: SmartphonePendingInspectionCompletion?
    private var installmentsViewModel: InstallmentsViewModelProtocol
    public var noGeoLocationAction: GenericAction

    // MARK: - Initializer

    /// Initializer
    /// - Parameters:
    ///   - smartphoneBusiness: Insurance Inspection List Manager
    ///   - insuranceData: Insurance Data
    ///   - hasSmartphoneProduct: user has smartphone product
    ///   - smartphoneListActions: Open inspection flow
    ///   - canIHelpYouAction: Action  can I Help You
    ///   - noGeoLocationAction: Action no GeoLocation
    ///   - noGeoLocationAction: Action no GeoLocation
    public required init(smartphoneBusiness: SmartphoneBusinessProtocol = SmartphoneBusiness(), insuranceData: [SmartphoneInsuranceData]?, hasSmartphoneProduct: Bool, smartphoneListActions: SmartphoneListActions? = nil, canIHelpYouAction: @escaping CanIHelpYouWhatsAppCompletion, noGeoLocationAction: @escaping GenericAction) {
        self.smartphoneBusiness = smartphoneBusiness
        
        installmentsViewModel = InstallmentsViewModel(financialDetailsAction: smartphoneListActions?.financialDetailsAction, canIHelpYouAction: canIHelpYouAction, smartphoneShortcutActions: smartphoneListActions?.smartphoneShortcutActions )
        self.hasSmartphoneProduct = hasSmartphoneProduct
        self.noGeoLocationAction = noGeoLocationAction
        smartphoneInsuranceData = insuranceData
        openValidationAction = smartphoneListActions?.openInspectionAction
        productUnavailableCompletion = smartphoneListActions?.productUnavailableCompletion
    }

    // MARK: Public Functions

    public func fetchInsuranceStatus(forceUpdate: Bool = false) {
        trackLoadingViewItem()
        sectionModels.value = [SmartphoneInsuranceListShimmerSectionModel()]

        viewState.value = isReloading ? .reloading : .loading
        isReloading = false

        var insuranceList: [String] = []
        smartphoneInsuranceData?.forEach {
            if let fullPolicy = $0.fullPolicy {
                insuranceList.append(fullPolicy)
            }
        }

        smartphoneBusiness.fetchInspectionList(forceUpdate: forceUpdate, insuranceList: insuranceList, apiVersion: nil) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let inspection):
                self.validateContent(inspectionList: inspection)
            case .failure:
                self.createErrorView()
                self.viewState.value = .error(nil)
            }
        }
    }

    public func updateSectionModelsForExpand(position: Int) {
        guard let listSectionModel = sectionModels.value[position] as? SmartphoneInsuranceListSectionModel else { return }
        sectionModels.value[position].isExpanded = true
        listSectionModel.headerViewModel?.updateHeaderStatus(isExpanded: true, type: listSectionModel.type)

        switch listSectionModel.type {
        case .inspection:
            guard let inspectionData = listSectionModel.contentData?.inspectionData else { return }
            sectionModels.value[position].contentViews = createInspectionContentViews(with: inspectionData)
        case .insurance:
            installmentsViewModel.smartphoneURLS = listSectionModel.contentData?.urls
            installmentsViewModel.smartphoneInsuranceData = listSectionModel.contentData?.insuranceData
            updateInsuranceViewModelValues()
            updateInsuranceContent(position: position, isReloading: false)
        }
    }

    private func updateInsuranceViewModelValues() {
        installmentsViewModel.updateSection = updateInsuranceContent
        installmentsViewModel.isExpanded = true
        installmentsViewModel.attemptsCount = .zero
    }

    private func updateInsuranceContent(position: Int, isReloading: Bool) {
        sectionModels.value[position].contentViews = installmentsViewModel.createInsuranceContentViews(installmentsData: nil, isLoading: true, shouldShowError: false, isCollectiveInvoice: false)
        if isReloading {
            viewState.value = .isFetchingInstallments
        }
        installmentsViewModel.currentPosition = position
        installmentsViewModel.fetchInstallmentsDetails(with: position) { [weak self] in
            if self?.sectionModels.value[position].isExpanded == true {
                self?.sectionModels.value[position].contentViews = $0
                self?.viewState.value = .didFetchInstallments
            }
        }
    }

    public func updateSectionModelsForCollapse(position: Int) {
        guard let listSectionModel = sectionModels.value[position] as? SmartphoneInsuranceListSectionModel else { return }
        listSectionModel.headerViewModel?.updateHeaderStatus(isExpanded: false, type: listSectionModel.type)

        sectionModels.value[position].isExpanded = false
        installmentsViewModel.isExpanded = false
        sectionModels.value[position].contentViews.removeAll()
    }

    public func trackExpandAndCollapse(isExpanded: Bool, position: Int) {
        guard let listSectionModel = sectionModels.value[position] as? SmartphoneInsuranceListSectionModel else { return }

        switch listSectionModel.type {
        case .inspection:
            trackExpandAndCollapseInspectionItem(isExpanded: isExpanded, sectionModel: listSectionModel)
        case .insurance:
            trackExpandAndCollapseInsuranceItem(isExpanded: isExpanded, insuranceData: listSectionModel.contentData?.insuranceData)
        }
    }

    // MARK: Private Functions

    private func validateContent(inspectionList: InspectionList?) {
        let insuranceDataList = smartphoneInsuranceData?.isEmpty ?? true
        let inspectionDataList = inspectionList?.inspection?.isEmpty ?? true
        
        if insuranceDataList, inspectionDataList {
            createCrossSellState(url: inspectionList?.urls?.portoStore ?? String())
            return
        }

        processViews(insuranceData: smartphoneInsuranceData, inspectionData: inspectionList?.inspection, urls: inspectionList?.urls)
        viewState.value = .success(sectionModels.value)
    }

    private func createErrorView() {
        trackErrorViewItem()
        sectionModels.value = [SmartphoneListErrorSectionModel(buttonAction: tryAgainAction, errorCount: attemptsCount)]
    }

    private func tryAgainAction() {
        attemptsCount += 1
        SmartphoneListErrorAnalytics.trackSmartphoneErrorReloadingAction()
        fetchInsuranceStatus()
    }

    private func processViews(insuranceData: [SmartphoneInsuranceData]?, inspectionData: [InspectionDataModel]?, urls: InspectionURLS?) {
        var sections: [SmartphoneInsuranceListSectionModel] = []

        let insuranceItems = insuranceData?.count ?? .zero
        let inspectionItems = inspectionData?.count ?? .zero
        let isUnique = inspectionItems + insuranceItems == 1

        for inspection in inspectionData ?? [] {
            let headerView = createHeaderView(with: inspection, insurance: nil, isUnique)
            let contentData = ContentData(insuranceData: nil, inspectionData: inspection, urls: urls)
            sections.append(SmartphoneInsuranceListSectionModel(headerView: headerView.0, contentViews: [], isExpanded: false, type: .inspection, contentData: contentData, headerViewModel: headerView.1))
        }
        
        for insurance in insuranceData ?? [] {
            let headerView = createHeaderView(with: nil, insurance: insurance, false)
            let contentData = ContentData(insuranceData: insurance, inspectionData: nil, urls: urls)
            sections.append(SmartphoneInsuranceListSectionModel(headerView: headerView.0, contentViews: [], isExpanded: false, type: .insurance, contentData: contentData, headerViewModel: headerView.1))
        }
        
        sectionModels.value = sections
    }

    private func createCrossSellState(url: String) {
        hasSmartphoneProduct = false
        let crossSellModel = [SmartphoneListCrossSellSectionModel(url: url, delegate: self)]
        sectionModels.value = crossSellModel
        viewState.value = .success(crossSellModel)
        trackCrossSellViewItem()
    }

    private func createHeaderView(with inspection: InspectionDataModel?, insurance: SmartphoneInsuranceData?, _ isUnique: Bool) -> (UIView, SmartphoneInsuranceHeaderViewModel) {
        let insuranceHeaderView = SmartphoneInsuranceHeaderView()
        if let inspection = inspection {
            let viewModel = SmartphoneInsuranceHeaderViewModel(with: inspection, insuranceData: nil, isExpanded: false)
            insuranceHeaderView.setup(with: viewModel, isUnique: isUnique)
            return (insuranceHeaderView, viewModel)
        }
        if let insurance = insurance {
            let viewModel = SmartphoneInsuranceHeaderViewModel(with: nil, insuranceData: insurance, isExpanded: false)
            insuranceHeaderView.setup(with: viewModel, isUnique: isUnique)
            let accessibilityString = String(format: AccessibilityLocalizableBundle.smartphoneInsurancePolicyNumber.accessibilityLocalize, insurance.insurancePolicy ?? String(), insurance.insuranceHolder ?? String())
            viewModel.headerViewModel?.accessibility.value = AccessibilityViewModel(label: accessibilityString, traits: .staticText)
            return (insuranceHeaderView, viewModel)
        }
        return (insuranceHeaderView, SmartphoneInsuranceHeaderViewModel(with: nil, insuranceData: nil, isExpanded: false))
    }

    private func createInspectionContentViews(with inspection: InspectionDataModel) -> [UIView] {
        var contentViews: [UIView] = []

        switch inspection.inspectionStatus {
        case .processing:
            contentViews.append(createInAnalysisView(with: inspection))
            trackGenericViewItem(with: inspection, screenClass: String(describing: InspectionInAnalysisView.self))
        case .refused, .refusedImei, .declinedProposePayment, .refusedModel, .refusedStorage, .declinedPropose, .declinedDisplay, .declinedTouch:
            contentViews.append(createRefusedView(with: inspection))
            trackGenericViewItem(with: inspection, screenClass: String(describing: InspectionRefusedView.self))
        case .pending:
            contentViews.append(createPendingView(with: inspection))
            trackPendingValidationViewItem(with: inspection)
        default:
            return contentViews
        }

        return contentViews
    }

    private func createPendingView(with inspection: InspectionDataModel) -> UIView {
        let contentView = SmartphoneInsurancePendingValidationView()
        let viewModel = SmartphoneInsurancePendingValidationViewModel(openValidationAction: openValidationAction)
        viewModel.dueDays.value = inspection.dueDays
        viewModel.deviceInspectionData = inspection
        viewModel.verificationResultDelegate = self
        contentView.setup(withViewModel: viewModel)
        return contentView
    }

    private func createInAnalysisView(with inspection: InspectionDataModel) -> UIView {
        let contentView = InspectionInAnalysisView()
        let analysisModel = InspectionInAnalysisView.Model(status: inspection.inspectionStatus, email: inspection.inspectionItems?.first?.email, proposeNumber: inspection.proposeNumber)
        contentView.setup(model: analysisModel)
        return contentView
    }

    private func createRefusedView(with inspection: InspectionDataModel) -> UIView {
        let contentView = InspectionRefusedView()
        let viewModel = InspectionRefusedViewModel(status: inspection.inspectionStatus, motive: inspection.inspectionItems?.first?.refusalMotive)
        contentView.setup(viewModel: viewModel)
        return contentView
    }

    // MARK: - Analytics

    // Inspection

    private func trackPendingValidationViewItem(with data: InspectionDataModel) {
        let manufacturer = data.inspectionItems?.first?.inspectionEquipment?.equipmentBrandName
        let model = data.inspectionItems?.first?.inspectionEquipment?.comercialModel
        let message = AnalyticsLabels.smartphonePendingValidationTitle.rawValue

        let device = SmartphoneDeviceInformationAnalyticsModel(manufacturer: manufacturer, model: model, messageDescription: message, alertMessage: message)

        SmartphonePendingInspectionAnalytics.trackSmartphonePedingValidationViewItem(itemName: AnalyticsItemName.smartphoneHome.rawValue, screenClass: String(describing: SmartphoneInsurancePendingValidationView.self), deviceInformation: device)
    }

    private func trackExpandAndCollapseInspectionItem(isExpanded: Bool, sectionModel: SmartphoneInsuranceListSectionModel) {
        let manufacturer = sectionModel.contentData?.inspectionData?.inspectionItems?.first?.inspectionEquipment?.equipmentBrandName
        let model = sectionModel.contentData?.inspectionData?.inspectionItems?.first?.inspectionEquipment?.comercialModel
        let descriptionLabel = LocalizableBundle.smartphonePendingHiringTitle.localize

        let device = SmartphoneDeviceInformationAnalyticsModel(manufacturer: manufacturer, model: model, messageDescription: descriptionLabel)
        SmartphonePendingInspectionAnalytics.trackCollapseExpandHeader(isExpanded: isExpanded, deviceInformation: device)
    }

    // Insurance

    private func trackExpandAndCollapseInsuranceItem(isExpanded: Bool, insuranceData: SmartphoneInsuranceData?) {
        SmartphoneInsuranceAnalytics.trackCollapseExpandHeader(isExpanded: isExpanded, policyNumber: insuranceData?.insurancePolicy ?? String())
    }

    // Loading and Errors

    private func trackLoadingViewItem() {
        SmartphonePendingInspectionAnalytics.trackSmartphoneLoadingViewItem(itemName: AnalyticsItemName.smartphoneHome.rawValue, screenClass: String(describing: SmartphoneHeaderShimmerView.self), deviceInformation: nil)
    }

    private func trackErrorViewItem() {
        let errorMessage = LocalizableBundle.smartphonePendingValidationErrorMessage.localize
        let device = SmartphoneDeviceInformationAnalyticsModel(messageDescription: errorMessage)

        SmartphoneListErrorAnalytics.trackSmartphoneErrorViewItem(itemName: AnalyticsItemName.smartphoneHome.rawValue, screenClass: String(describing: InspectionListErrorView.self), deviceInformation: device)
    }
}

extension SmartphoneInsuranceListViewModel {
    
    // Generic

    private func trackGenericViewItem(with data: InspectionDataModel, screenClass: String) {
        let manufacturer = data.inspectionItems?.first?.inspectionEquipment?.equipmentBrandName
        let model = data.inspectionItems?.first?.inspectionEquipment?.comercialModel
        var descriptionLabel = String()
        var alertMessage = AnalyticsLabels.smartphoneRefusedStatusTitle.rawValue

        switch data.inspectionStatus {
        case .processing:
            alertMessage = AnalyticsLabels.smartphonePendingHiringTitle.rawValue
            descriptionLabel = AnalyticsLabels.smartphonePendingHiringTitle.rawValue
        case .refused, .refusedModel, .refusedImei, .refusedStorage, .declinedDisplay, .declinedTouch:
            descriptionLabel = getRefusedDescriptionLabel(status: data.inspectionStatus)
        case .declinedPropose, .declinedProposePayment:
            descriptionLabel = AnalyticsLabels.smartphoneDeclinedProposeStatusMessage.rawValue
        default:
            descriptionLabel = String()
        }

        let device = SmartphoneDeviceInformationAnalyticsModel(manufacturer: manufacturer, model: model, messageDescription: descriptionLabel, alertMessage: alertMessage)
        SmartphoneGenericViewAnalytics.trackSmartphoneGenericViewItem(itemName: AnalyticsItemName.smartphoneHome.rawValue, screenClass: screenClass, deviceInformation: device)
    }

    private func getRefusedDescriptionLabel(status: InspectionStatus?) -> String {
        let label = AnalyticsLabels.smartphoneRefusedStatusMessage.rawValue

        switch status {
        case .refused:
            return String(format: label, AnalyticsAlert.genericStatus.rawValue)
        case .refusedStorage:
            return String(format: label, AnalyticsAlert.deviceStorage.rawValue)
        case .refusedModel:
            return String(format: label, AnalyticsAlert.deviceModel.rawValue)
        case .refusedImei:
            return String(format: label, AnalyticsAlert.imeiBlocked.rawValue)
        default:
            return label
        }
    }
    
    // Empty View
    private func trackSmartphoneNewsComing() {
        SmartphoneInspectionAnalytics.trackSmartphoneNewsComing(itemName: AnalyticsItemName.smartphoneHomeNewsComing.rawValue, screenClass: String(describing: SmartphoneInsuranceCrossSellView.self))
    }
    
    private func trackCrossSellViewItem() {
        if FeatureToggle.isAvailable(.smartphoneEmptyCrossSell) {
            SmartphoneInspectionAnalytics.trackCrossSellViewItem(clientId: getClientId(), screenClass: String(describing: SmartphoneInsuranceCrossSellOffersView.self))
        } else {
            trackSmartphoneNewsComing()
        }
    }
    
    private func getClientId() -> String {
        let loginData: LoginUserData? = try? DataStorage.value(method: .safe(service: .userSecurity), forKey: KeyChainStorageKeys.loginUserData.rawValue)
        
        return loginData?.hashUserCpf ?? String()
    }
}

// MARK: - VerificationResultDelegate

extension SmartphoneInsuranceListViewModel: VerificationResultDelegate {
    public func reloadSmartphone() {
        DispatchQueue.main.asyncAfter(deadline: delayTimeToAsyncAnimation) { [weak self] in
            guard let self = self else { return }
            self.isReloading = true
            self.fetchInsuranceStatus(forceUpdate: true)
        }
    }
}

// MARK: - CrossSellOffersViewDelegate

extension SmartphoneInsuranceListViewModel: CrossSellOffersViewDelegate {
    func didClickMakeQuote(url: String) {
        SmartphoneInspectionAnalytics.trackCrossSellSelectContent(clientId: getClientId())
        
        if let portoURL = URL(string: url), UIApplication.shared.canOpenURL(portoURL) {
            UIApplication.shared.open(portoURL, options: [:], completionHandler: nil)
        }
    }
}
 
