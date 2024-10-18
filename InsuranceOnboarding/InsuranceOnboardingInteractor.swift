//
//  InsuranceOnboardingInteractor.swift
//  Smartphone
//
//  Created by Dennis Torres on 02/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

import Foundation

enum InsuranceOnboardingFlow {
    case hub(urlString: String?), `internal`
}

protocol InsuranceOnboardingInteracting: AnyObject {
    var couponDiscount: String? { get set }
    
    func prepare()
    func dismiss()
    func openInternal()
    func openURL(url: String?)
}

final class InsuranceOnboardingInteractor {
    var couponDiscount: String?
    
    private let service: InsuranceOnboardingServicing
    private let presenter: InsuranceOnboardingPresenting

    init(service: InsuranceOnboardingServicing, presenter: InsuranceOnboardingPresenting) {
        self.service = service
        self.presenter = presenter
    }
}

extension InsuranceOnboardingInteractor: InsuranceOnboardingInteracting {
    func prepare() {
        presenter.presentLoading()
        
        let deviceInfo = SmartphoneDeviceInformation()
        let requestParam = OnboardingParameters(
            manufacturer: deviceInfo.manufacturer,
            model: deviceInfo.model,
            internalStorage: deviceInfo.internalStorage,
            cupomDesconto: couponDiscount
        )
        service.fetchOnboarding(requestParam: requestParam) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let response):
                presenter.presentComponents(with: response.benefits)
                setupButtonAction(with: response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func dismiss() {
        presenter.dismissFlow()
    }
    
    func openInternal() {
        presenter.presentInternal(couponDiscount: couponDiscount)
    }
    
    func openURL(url: String?) {
        presenter.presentURL(url: url)
    }
}

extension InsuranceOnboardingInteractor {
    private func setupButtonAction(with data: OnboardingDataResponse) {
        let shouldDirectToInternal =
        data.cardList != nil &&
        data.deviceData != nil &&
        data.personData != nil
        
        let flow: InsuranceOnboardingFlow = {
            guard !shouldDirectToInternal else {
                return .internal
            }
            let urlHUB: String = LocalizableBundle.smartphoneInsuranceUrlHUB.localize
            return .hub(urlString: urlHUB)
        }()
        
        presenter.presentButtonAction(shouldDirectTo: flow)
    }
}
