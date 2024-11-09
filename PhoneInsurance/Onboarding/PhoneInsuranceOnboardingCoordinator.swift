//
//  PhoneInsuranceOnboardingCoordinator.swift
//  Smartphone
//
//  Created by Dennis Torres on 02/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

import UIKit
import Core

// MARK: - Enums

enum PhoneInsuranceOnboardingAction {
    case back
    case loadingScreen
    case openURL(url: String?)
}

enum PhoneInsuranceErrorAction {
    case dismiss
    case present(_ delegate: PhoneInsuranceErrorViewDelegate, _ errorType: PhoneInsuranceErrorType)
}

// MARK: - Protocols

protocol PhoneInsuranceOnboardingCoordinating: AnyObject {
    var viewController: UIViewController? { get set }
    
    func perform(action: PhoneInsuranceOnboardingAction)
    func performError(action: PhoneInsuranceErrorAction)
}

// MARK: - Coordinator

final class PhoneInsuranceOnboardingCoordinator {
    // MARK: - Properties
    
    weak var viewController: UIViewController?
    
    private var errorViewController: PhoneInsuranceErrorViewController?
    private let context = PhoneInsuranceContext.shared

    // MARK: - Initialization
    
    init(coupon: String?, deviceInfo: SmartphoneDeviceInformationProtocol?) {
        context.set(\.coupon, to: coupon )
        context.set(\.deviceInfo, to: deviceInfo)
    }
    
    deinit {
        context.resetProperties()
    }
}

// MARK: - PhoneInsuranceOnboardingCoordinating

extension PhoneInsuranceOnboardingCoordinator: PhoneInsuranceOnboardingCoordinating {
    
    // MARK: - Methods
    
    func perform(action: PhoneInsuranceOnboardingAction) {
        switch action {
        case .back:
            viewController?.navigationController?.popViewController(animated: true)
            errorViewController?.dismiss(animated: true)
        case .loadingScreen:
            let loadingVC = PhoneInsuranceLoadingFactory.make()
            viewController?.navigationController?.pushViewController(loadingVC, animated: false)
        case .openURL(let urlString):
            guard let urlString, let url = URL(string: urlString) else { return }
            DeepLinkHiddenModeHandler.processDeepLink(with: url)
        }
    }
    
    func performError(action: PhoneInsuranceErrorAction) {
        switch action {
        case .dismiss:
            errorViewController?.dismiss(animated: true)
        case .present(let delegate, let type):
            errorViewController = PhoneInsuranceErrorViewController(delegate: delegate, errorType: type)
            
            guard let errorViewController else { return }
            errorViewController.modalPresentationStyle = .fullScreen
            viewController?.present(errorViewController, animated: true)
        }
    }
}
