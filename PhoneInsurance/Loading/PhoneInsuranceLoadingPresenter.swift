//
//  PhoneInsuranceLoadingPresenter.swift
//  Smartphone
//
//  Created by Dennis Torres on 02/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

import Foundation

protocol PhoneInsuranceLoadingPresenting: AnyObject {
    var viewController: PhoneInsuranceLoadingDisplaying? { get set }
    
    func presentComponents(with model: LoadingProgressResponse, loadingTime: Float)
    func presentCurrentLoadingTime(currentTime: Float, progressText: String?)
    func presentFadeInTransitionCard()
    func presentInternalScreen()
    func presentURL(url: String?)
    func presentError(_ delegate: PhoneInsuranceErrorViewDelegate, _ errorType: PhoneInsuranceErrorType)
    func dismissFlow()
    func dismissError()
}

final class PhoneInsuranceLoadingPresenter {
    weak var viewController: PhoneInsuranceLoadingDisplaying?
    private let coordinator: PhoneInsuranceLoadingCoordinating

    init(coordinator: PhoneInsuranceLoadingCoordinating) {
        self.coordinator = coordinator
    }
}

extension PhoneInsuranceLoadingPresenter: PhoneInsuranceLoadingPresenting {
    func presentComponents(with model: LoadingProgressResponse, loadingTime: Float) {
        viewController?.displayComponents(with: model, loadingTime: loadingTime)
    }
    
    func presentCurrentLoadingTime(currentTime: Float, progressText: String?) {
        viewController?.displayNewProgressTime(currentTime: currentTime, progressText: progressText)
    }
    
    func presentFadeInTransitionCard() {
        viewController?.displayFadeInTransitionCard()
    }
    
    func presentInternalScreen() {
        coordinator.perform(action: .internal)
    }
    
    func presentURL(url: String?) {
        coordinator.perform(action: .openURL(url: url))
    }
    
    func presentError(_ delegate: PhoneInsuranceErrorViewDelegate, _ errorType: PhoneInsuranceErrorType) {
        coordinator.performError(action: .present(delegate, errorType))
    }
    
    func dismissFlow() {
        coordinator.perform(action: .back)
    }
    
    func dismissError() {
        coordinator.performError(action: .dismiss)
    }
}
