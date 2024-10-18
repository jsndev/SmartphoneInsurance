//
//  InsuranceInternalViewController.swift
//  Smartphone
//
//  Created by Dennis Torres on 02/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

import DesignSystem
import UIKit

protocol InsuranceInternalDisplaying: AnyObject {
    func displayComponents()
    func displayLoading()
}

final class InsuranceInternalViewController: UIViewController {
    private enum Layout {
        static let backgroundColor: UIColor = .portoSeguros100
    }
    
    private let interactor: InsuranceInternalInteracting
    
    init(interactor: InsuranceInternalInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor.prepare()
    }

    public func buildViewHierarchy() {
        
    }
    
    public func buildViewConstraints() {
        
    }

    public func additionalConfig() {
        
    }
}

extension InsuranceInternalViewController: InsuranceInternalDisplaying {
    func displayComponents() {
        // exibir componentes
    }
    
    func displayLoading() {
        // shimmer
    }
}
