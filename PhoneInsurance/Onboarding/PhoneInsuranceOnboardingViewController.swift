//
//  PhoneInsuranceOnboardingViewController.swift
//  Smartphone
//
//  Created by Dennis Torres on 02/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

import DesignSystem
import UIKit

protocol PhoneInsuranceOnboardingDisplaying: AnyObject {
    func displayComponents(data: BenefitsResponse)
    func displayLoading()
    func setupActions(shouldDirectTo flow: PhoneInsuranceOnboardingFlow)
}

final class PhoneInsuranceOnboardingViewController: PhoneInsuranceBaseViewController<PhoneInsuranceOnboardingInteracting, InsuranceOnboardingView> {
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor.fetchOnboardingData()
    }
    
    // MARK: - ViewCodable
    
    override func additionalConfig() {
        rootView.dismissAction = { [weak self] in
            guard let self = self else { return }
            self.interactor.close()
        }
    }
}

// MARK: - PhoneInsuranceOnboardingDisplaying

extension PhoneInsuranceOnboardingViewController: PhoneInsuranceOnboardingDisplaying {
    
    func displayComponents(data: BenefitsResponse) {
        rootView.stopShimmerView()
        rootView.setup(with: data)
    }
    
    func displayLoading() {
        rootView.stopShimmerView()
        rootView.startShimmerView()
    }
    
    func setupActions(shouldDirectTo flow: PhoneInsuranceOnboardingFlow) {
        rootView.buttonAction = { [weak self] in
            guard let self = self else { return }
            switch flow {
            case .hub(let urlString):
                self.interactor.openURL(url: urlString)
            case .loadingScreen:
                self.interactor.openInternal()
            }
        }
    }
}
