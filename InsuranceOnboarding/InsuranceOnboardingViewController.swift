//
//  InsuranceOnboardingViewController.swift
//  Smartphone
//
//  Created by Dennis Torres on 02/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

import DesignSystem
import UIKit

protocol InsuranceOnboardingDisplaying: AnyObject {
    func displayComponents(data: BenefitsResponse)
    func displayLoading()
    func setupActions(shouldDirectTo flow: InsuranceOnboardingFlow)
}

final class InsuranceOnboardingViewController: UIViewController {
    private enum Layout {
        static let backgroundColor: UIColor = .portoSeguros100
    }
    
    private lazy var onboardingView: InsuranceOnboardingView = {
        let onbView = InsuranceOnboardingView()
        onbView.setupWithDummyViews()
        return onbView
    }()
    
    private let interactor: InsuranceOnboardingInteracting
    
    init(interactor: InsuranceOnboardingInteracting) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = Layout.backgroundColor
        buildViewHierarchy()
        setupActions()
        interactor.prepare()
    }
}

extension InsuranceOnboardingViewController: InsuranceOnboardingDisplaying {
    func displayComponents(data: BenefitsResponse) {
        onboardingView.stopShimmerView()
        onboardingView.setup(with: data)
    }
    
    func displayLoading() {
        onboardingView.startShimmerView()
    }
    
    func setupActions(shouldDirectTo flow: InsuranceOnboardingFlow) {
        onboardingView.buttonAction = { [weak self] in
            guard let self = self else { return }
            switch flow {
            case .hub(let urlString):
                self.interactor.openURL(url: urlString)
            case .internal:
                self.interactor.openInternal()
            }
        }
    }
}

extension InsuranceOnboardingViewController {
    private func buildViewHierarchy() {
        view.addSubview(onboardingView, applyConstraints: true)
    }
    
    private func setupActions() {
        onboardingView.dismissAction = { [weak self] in
            guard let self = self else { return }
            self.interactor.dismiss()
        }
    }
}
