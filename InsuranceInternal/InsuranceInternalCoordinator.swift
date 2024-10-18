//
//  InsuranceInternalCoordinator.swift
//  Smartphone
//
//  Created by Dennis Torres on 02/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

import UIKit

enum InsuranceInternalAction {
    case back
}

protocol InsuranceInternalCoordinating: AnyObject {
    var viewController: UIViewController? { get set }

    func perform(action: InsuranceInternalAction)
}

final class InsuranceInternalCoordinator {
    weak var viewController: UIViewController?
}

extension InsuranceInternalCoordinator: InsuranceInternalCoordinating {
    func perform(action: InsuranceInternalAction) {
        switch action {
        case .back:
            viewController?.navigationController?.popViewController(animated: true)
        }
    }
}
