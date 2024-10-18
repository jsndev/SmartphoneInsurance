//
//  InstallmentsViewModel.swift
//  Smartphone
//
//  Created by Hugo Hernany da Silva Cabral on 10/05/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Core
import Insurance

public protocol InstallmentsViewModelProtocol {
    /// Update Section in specific position in reloading after error
    var updateSection: ((Int, Bool) -> Void)? { get set }
    /// Insurance Data
    var smartphoneInsuranceData: SmartphoneInsuranceData? { get set }
    /// URLs for insurances
    var smartphoneURLS: InspectionURLS? { get set }
    /// Cell position
    var currentPosition: Int? { get set }
    /// Cell status
    var isExpanded: Bool { get set }
    /// Retry counter after an error occurs
    var attemptsCount: Int { get set }

    /// Cretate Insurance Views
    func createInsuranceContentViews(installmentsData: FinancialDetailsResponse?, isLoading: Bool, shouldShowError: Bool, isCollectiveInvoice: Bool) -> [UIView]
    /// Fetch Insurance Installments
    func fetchInstallmentsDetails(with position: Int, completion: @escaping ([UIView]) -> Void)
}

class InstallmentsViewModel: InstallmentsViewModelProtocol {
    // MARK: - Private Properties

    public var attemptsCount: Int = .zero

    // MARK: - Public Properties

    public var contentViews = Dynamic<[UIView]?>(nil)
    public var smartphoneInsuranceData: SmartphoneInsuranceData?
    public var smartphoneURLS: InspectionURLS?
    public var updateSection: ((Int, Bool) -> Void)?
    public var currentPosition: Int?
    public var isExpanded = false
    private var currentFinancialDetails: FinancialDetailsResponse?

    // MARK: - Dynamic Properties

    public var viewState = Dynamic<SmartphoneInsuranceListViewState>(.isFetchingInstallments)

    // MARK: - Private Constants

    private let smartphoneBusiness: SmartphoneBusinessProtocol
    private let financialDetailsAction: SmartphoneFinancialDetailsCompletion?
    private let canIHelpYouAction: CanIHelpYouWhatsAppCompletion
    private let smartphoneShortcutActions: SmartphoneShortcutActions?

    // MARK: - Initializer

    /// Initializer
    /// - Parameters:
    ///   - financialDetailsManager: Manager to fetch installments data
    ///   - insuranceData: Insurance Data received from login
    public required init(smartphoneBusiness: SmartphoneBusinessProtocol = SmartphoneBusiness(), financialDetailsAction: SmartphoneFinancialDetailsCompletion?, canIHelpYouAction: @escaping CanIHelpYouWhatsAppCompletion, smartphoneShortcutActions: SmartphoneShortcutActions?) {
        self.smartphoneBusiness = smartphoneBusiness
        self.financialDetailsAction = financialDetailsAction
        self.canIHelpYouAction = canIHelpYouAction
        self.smartphoneShortcutActions = smartphoneShortcutActions
    }

    func fetchInstallmentsDetails(with position: Int, completion: @escaping ([UIView]) -> Void) {
        guard FeatureToggle.isAvailable(.smartphoneFinancialDetails) else { return }

        viewState.value = .isFetchingInstallments

        guard let fullPolicyNumber = smartphoneInsuranceData?.fullPolicy else { return }

        smartphoneBusiness.fetchFinancialDetails(fullPolicyNumber: fullPolicyNumber) { [weak self] result in
            guard let self = self else { return }

            if position != self.currentPosition || !self.isExpanded {
                return
            }

            switch result {
            case let .success(response):
                self.viewState.value = .didFetchInstallments
                completion(self.createInsuranceContentViews(installmentsData: response, isLoading: false, shouldShowError: false))
            case let .failure(error):
                let isCollectiveInvoice = error.isCollectiveInvoiceError
                self.viewState.value = isCollectiveInvoice ? .didFetchInstallments : .errorInstallmentsFetch
                completion(self.createInsuranceContentViews(installmentsData: nil, isLoading: false, shouldShowError: error.isPresentableError, isCollectiveInvoice: isCollectiveInvoice))
            }
        }
    }

    func createInsuranceContentViews(installmentsData: FinancialDetailsResponse?, isLoading: Bool, shouldShowError: Bool, isCollectiveInvoice: Bool = false) -> [UIView] {
        currentFinancialDetails = installmentsData

        if isLoading {
            viewState.value = .isFetchingInstallments
        }
        guard let insuranceData = smartphoneInsuranceData else { return [] }
        let financialDetailsToggle = FeatureToggle.isAvailable(.smartphoneFinancialDetails)

        var views: [UIView] = []

        let remainingDaysView = InsuranceRemainingDaysView()
        remainingDaysView.setup(with: insuranceData)
        views.append(remainingDaysView)

        if financialDetailsToggle, !isCollectiveInvoice {
            let installmentsView = setupInstallmentsViews(installmentsData: installmentsData, shouldShowError: shouldShowError)
            views.append(contentsOf: installmentsView)
        }

        let shortcutView = InsuranceShortcutsView()
        let viewModel = InsuranceShortcutsViewModel(showSeparatorView: financialDetailsToggle, smartphoneInsuranceData: insuranceData, urls: smartphoneURLS, canIHelpYouAction: canIHelpYouAction, smartphoneShortcutActions: smartphoneShortcutActions)
        shortcutView.setup(viewModel: viewModel)
        views.append(shortcutView)

        trackInsuranceViewItem()

        return views
    }

    private func setupInstallmentsViews(installmentsData: FinancialDetailsResponse?, shouldShowError: Bool) -> [UIView] {
        switch viewState.value {
        case .didFetchInstallments:
            viewState.value = .isFetchingInstallments
            trackPaymentBarPresented(financialDetails: installmentsData, isSuccess: true, shouldShowError: shouldShowError)
            return createInstallmentsView(isLoading: false, installmentsData: installmentsData)
        case .isFetchingInstallments:
            return createInstallmentsView(isLoading: true, installmentsData: installmentsData)
        case .errorInstallmentsFetch:
            let errorView = createErrorView(installmentsData: installmentsData, shouldShowError: shouldShowError)
            return [errorView]
        default:
            return []
        }
    }

    private func createInstallmentsView(isLoading: Bool, installmentsData: FinancialDetailsResponse?) -> [UIView] {
        var views: [UIView] = []

        let action: InstallmentsDetailsAction? = FeatureToggle.isAvailable(.smartphoneFinancialSeeDetails) ? seeDetailsAction : nil
        let viewModel = SmartphoneInstallmentsViewModel(with: installmentsData, action: action)
        viewModel.isLoading.value = isLoading
        let installmentsView = SmartphoneInstallmentsView()
        installmentsView.setup(with: viewModel)
        views.append(installmentsView)

        if let financialDetails = installmentsData {
            let installmentsMessage = financialDetails.installmentMessage

            if financialDetails.isPaidOff, !isLoading {
                let paidMessageViewModel = SmartphoneInstallmentsMessageViewModel(
                    messageData: .init(value: installmentsMessage?.value, date: installmentsMessage?.date, type: .policyPaidOff),
                    action: nil
                )
                views.append(createMessageView(with: paidMessageViewModel, shouldShimmerize: isLoading))
                trackFinancialMessagesPresented(financialDetails: financialDetails, for: .policyPaidOff)
            }

            if financialDetails.shouldShowDelayAlert, !isLoading {
                let delayMessageViewModel = SmartphoneInstallmentsMessageViewModel(
                    messageData: .init(value: installmentsMessage?.value, date: installmentsMessage?.date, type: .pendingInstallments)
                )
                views.append(createMessageView(with: delayMessageViewModel, shouldShimmerize: isLoading))
                trackFinancialMessagesPresented(financialDetails: financialDetails, for: .pendingInstallments)
            }

            if let installmentMessage = financialDetails.installmentMessage {
                let messageData = FinancialMessageData(
                    value: installmentMessage.value,
                    date: installmentMessage.date,
                    type: FinancialMessageType(convertedFrom: installmentMessage.type)
                )
                let installmentsMessageViewModel = SmartphoneInstallmentsMessageViewModel(messageData: messageData)
                views.append(createMessageView(with: installmentsMessageViewModel, shouldShimmerize: isLoading))

                if let installmentMessageType = financialDetails.installmentMessage?.type, !isLoading {
                    let messageType = FinancialMessageType(convertedFrom: installmentMessageType)
                    trackFinancialMessagesPresented(financialDetails: financialDetails, for: messageType)
                }
            }
        } else {
            views.append(createMessageView(with: nil, shouldShimmerize: isLoading))
        }

        return views
    }

    private func createErrorView(installmentsData: FinancialDetailsResponse?, shouldShowError: Bool) -> UIView {
        if shouldShowError {
            trackPaymentBarPresented(financialDetails: installmentsData, isSuccess: false, shouldShowError: shouldShowError)
            let errorSection = SmartphoneListErrorSectionModel(buttonAction: tryAgainAction, errorCount: attemptsCount, message: LocalizableBundle.smartphoneInstallmentsErrorMessage.localize, topConstraint: .zero, bottomConstraint: .zero, roundedCorners: false)
            let errorView = errorSection.headerView
            return errorView
        } else {
            return UIView()
        }
    }

    private func createMessageView(with viewModel: SmartphoneInstallmentsMessageViewModelProtocol?, shouldShimmerize: Bool) -> UIView {
        let installmentsMessageView = SmartphoneInstallmentsMessageView()
        installmentsMessageView.setup(with: viewModel, shouldShimmerize: shouldShimmerize)
        return installmentsMessageView
    }

    private func seeDetailsAction() {
        guard let financialDetails = currentFinancialDetails else { return }

        trackButtonAction(buttonName: LocalizableBundle.paymentBarButtonTitle.localize)

        let smartphonePolicy = SmartphonePolicy(endorsement: String(), policyNumber: smartphoneInsuranceData?.insurancePolicy ?? String(), fullPolicyNumber: smartphoneInsuranceData?.fullPolicy ?? String())
        let policy = FlutterModelConverter().convertToSmartphonePolicyFlutter(from: smartphonePolicy)
        let financialModel = FlutterFinancialDetailsData(smartphonePolicy: policy, financialDetails: financialDetails)

        let flutterParameter = FlutterFinancialParameter(
            initialRoute: .financial(.details),
            product: .smartphone,
            model: .init(financialModel: financialModel),
            actions: .init {
                /* Intentionally unimplemented */
            }
        )

        financialDetailsAction?(flutterParameter)
    }

    private func tryAgainAction() {
        attemptsCount += 1
        guard let position = currentPosition else { return }
        updateSection?(position, true)
    }

    // MARK: - Analytics

    private func trackInsuranceViewItem() {
        SmartphoneInsuranceAnalytics.trackSmartphoneInsuranceViewItem(itemName: AnalyticsItemName.smartphoneHome.rawValue, screenClass: String(describing: SmartphoneInsurancePendingValidationView.self))
    }

    private func trackButtonAction(buttonName: String) {
        SmartphoneInsuranceAnalytics.trackButtonAction(buttonName: buttonName, policyNumber: smartphoneInsuranceData?.insurancePolicy ?? String())
    }

    private func trackPaymentBarPresented(financialDetails: FinancialDetailsResponse?, isSuccess: Bool, shouldShowError: Bool) {
        guard let insuranceData = smartphoneInsuranceData else { return }

        if !isSuccess, shouldShowError {
            SmartphoneInsuranceAnalytics.trackPaymentBarError(policyNumber: insuranceData.insurancePolicy ?? String())
            return
        }

        guard let financialDetails = financialDetails, !financialDetails.installments.isEmpty else { return }

        SmartphoneInsuranceAnalytics.trackPaymentBarSuccess(policyNumber: insuranceData.insurancePolicy ?? String(), isDelayed: financialDetails.shouldShowDelayAlert, date: financialDetails.installmentMessage?.date)
    }

    private func trackFinancialMessagesPresented(financialDetails: FinancialDetailsResponse?, for type: FinancialMessageType) {
        guard let financialDetails = financialDetails, let insuranceData = smartphoneInsuranceData, let message = getFinancialMessage(financialDetails: financialDetails, for: type) else { return }
        let policyNumber = insuranceData.insurancePolicy ?? String()
        SmartphoneInsuranceAnalytics.trackFinancialMessages(policyNumber: policyNumber, message: message)
    }

    func getFinancialMessage(financialDetails: FinancialDetailsResponse, for type: FinancialMessageType) -> String? {
        let responseMessageAtPosition = financialDetails.installmentMessage
        let messageData = FinancialMessageData(value: responseMessageAtPosition?.value, date: responseMessageAtPosition?.date, type: type)

        return messageData.attributedMessage.string
    }
}
