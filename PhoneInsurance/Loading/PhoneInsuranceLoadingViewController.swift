//
//  PhoneInsuranceLoadingViewController.swift
//  Smartphone
//
//  Created by Dennis Torres on 02/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

import DesignSystem
import UIKit

protocol PhoneInsuranceLoadingDisplaying: AnyObject {
    func displayComponents(with model: LoadingProgressResponse, loadingTime: Float)
    func displayNewProgressTime(currentTime: Float, progressText: String?)
    func displayFadeInTransitionCard()
}

final class PhoneInsuranceLoadingViewController: PhoneInsuranceBaseViewController<PhoneInsuranceLoadingInteracting, PhoneInsuranceRequestingView> {

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor.prepare()
    }
}

// MARK: - PhoneInsuranceLoadingDisplaying

extension PhoneInsuranceLoadingViewController: PhoneInsuranceLoadingDisplaying {
    func displayComponents(with model: LoadingProgressResponse, loadingTime: Float) {
        rootView.setup(with: model, loadingTime: loadingTime)
    }
    
    func displayNewProgressTime(currentTime: Float, progressText: String?) {
        rootView.uploadProgress(currentTime: currentTime, progressText: progressText)
    }
    
    func displayFadeInTransitionCard() {
        rootView.startFadeInTransitionCard()
    }
}
