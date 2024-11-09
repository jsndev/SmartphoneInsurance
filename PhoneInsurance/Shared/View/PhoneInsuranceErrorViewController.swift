//
//  PhoneInsuranceErrorViewController.swift
//  abseil
//
//  Created by Jeff on 30/10/24.
//

import UIKit

typealias PhoneInsuranceErrorType = PhoneInsuranceErrorView.ErrorType

// MARK: - Delegate

protocol PhoneInsuranceErrorViewDelegate {
    func dismiss()
    func buttonAction(_ type: PhoneInsuranceErrorType)
}

final class PhoneInsuranceErrorViewController: UIViewController {
    
    // MARK: - Views
    
    private lazy var errorView = PhoneInsuranceErrorView()
    
    // MARK: - Properties
    
    private let errorType: PhoneInsuranceErrorType
    private let delegate: PhoneInsuranceErrorViewDelegate

    // MARK: - Initializer
    
    init(delegate: PhoneInsuranceErrorViewDelegate, errorType: PhoneInsuranceErrorType) {
        self.delegate = delegate
        self.errorType = errorType
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buildViewHierarchy()
        errorView.errorType = errorType
        
        errorView.dismissAction = {
            self.delegate.dismiss()
        }

        errorView.buttonAction = {
            self.delegate.buttonAction(self.errorType)
        }
    }
}

// MARK: - Private methods

extension PhoneInsuranceErrorViewController {
    
    private func buildViewHierarchy() {
        view.addSubview(errorView, applyConstraints: true)
    }
}
