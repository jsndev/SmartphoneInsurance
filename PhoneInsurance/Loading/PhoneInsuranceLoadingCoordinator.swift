//
//  PhoneInsuranceLoadingCoordinator.swift
//  Smartphone
//
//  Created by Dennis Torres on 02/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

import UIKit
import Core

enum InsuranceInternalAction {
    case back
    case `internal`
    case openURL(url: String?)
}

protocol PhoneInsuranceLoadingCoordinating: AnyObject {
    var viewController: UIViewController? { get set }
    
    func perform(action: InsuranceInternalAction)
    func performError(action: PhoneInsuranceErrorAction)
}

final class PhoneInsuranceLoadingCoordinator {
    weak var viewController: UIViewController?
    private var errorViewController: PhoneInsuranceErrorViewController?
}

// MARK: - PhoneInsuranceLoadingCoordinating

extension PhoneInsuranceLoadingCoordinator: PhoneInsuranceLoadingCoordinating {
    
    // MARK: - Methods
    
    func perform(action: InsuranceInternalAction) {
        switch action {
        case .back:
            viewController?.navigationController?.popViewController(animated: true)
            errorViewController?.dismiss(animated: true)
        case .internal:
            guard let navigationController = viewController?.navigationController,
                  navigationController.viewControllers.count > 2
            else { return }
            
            let internalVC = PhoneInsurancePlansFactory.make()
            navigationController.pushViewController(internalVC, animated: true)
            
            navigationController.viewControllers.remove(at: navigationController.viewControllers.count - 2)
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
