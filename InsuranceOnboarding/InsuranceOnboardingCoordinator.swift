//
//  InsuranceOnboardingCoordinator.swift
//  Smartphone
//
//  Created by Dennis Torres on 02/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

import UIKit

enum InsuranceOnboardingAction {
    case back
    case `internal`(couponDiscount: String?)
    case openURL(url: String?)
}

protocol InsuranceOnboardingCoordinating: AnyObject {
    var viewController: UIViewController? { get set }

    func perform(action: InsuranceOnboardingAction)
}

final class InsuranceOnboardingCoordinator {
    weak var viewController: UIViewController?
}

extension InsuranceOnboardingCoordinator: InsuranceOnboardingCoordinating {
    func perform(action: InsuranceOnboardingAction) {
        switch action {
        case .back:
            viewController?.navigationController?.popViewController(animated: true)
        case .internal(let couponDiscount):
            /*let internalVC = InsuranceInternalFactory.make()
            viewController?.navigationController?.pushViewController(internalVC, animated: false)*/
            print(couponDiscount)
        case .openURL(let urlString):
            guard let urlString,
                  let url = URL(string: urlString)
            else { return }
            UIApplication.shared.open(url)
        }
    }
}
