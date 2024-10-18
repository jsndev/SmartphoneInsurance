//
//  SmartphoneInstallmentsView.swift
//  Smartphone
//
//  Created by Hugo Hernany da Silva Cabral on 06/05/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Components
import Core
import UIKit

final class SmartphoneInstallmentsView: UIView {
    // MARK: - Constants

    private enum Constants {
        static let numberOfSpacesBetweenShimmers: CGFloat = 2
        static let numberOfShimmersInStack: CGFloat = 3
        static let spacesBetweenShimmers: CGFloat = 10
        static let totalSizeOfMarginView: CGFloat = 80
    }

    // MARK: - Private Properties

    private var viewModel: SmartphoneInstallmentsViewModelProtocol?

    // MARK: - Outlets

    @IBOutlet private weak var shimmerView: UIView? {
        didSet {
            shimmerView?.accessibilityLabel = AccessibilityLocalizableBundle.shimmerLoading.accessibilityLocalize
        }
    }

    @IBOutlet private weak var paymentBarView: PaymentBarView?

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        loadFromXib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        loadFromXib()
    }

    // MARK: - Instantiate

    func setup(with viewModel: BaseViewModel) {
        guard let viewModel = viewModel as? SmartphoneInstallmentsViewModelProtocol else { return }
        self.viewModel = viewModel

        configureBinds()

        guard let properties = viewModel.properties else { return }

        let paymentBarTitle: PaymentBarTitle = .init(regularText: properties.titleRegular, boldText: properties.titleBold)
        let paymentBarInstallments: [PaymentBarItemStatus] = properties.installmentsStatus.map {
            switch $0 {
            case .paid:
                return .processed
            case .delayed:
                return .pending
            case .current:
                return .next
            case .future:
                return .future
            }
        }
        var paymentBarButtonProperties: PaymentBarButtonProperties?
        if let buttonTitle = properties.buttonTitle, let buttonAction = properties.buttonAction {
            paymentBarButtonProperties = .init(title: buttonTitle, action: buttonAction)
        }

        let paymentBarViewModel = PaymentBarViewModel(title: paymentBarTitle, items: paymentBarInstallments, buttonProperties: paymentBarButtonProperties)
        paymentBarViewModel.accessibility.value = viewModel.accessibilityViewModel

        paymentBarView?.viewModel = paymentBarViewModel
    }

    // MARK: - Private Methods

    private func configureBinds() {
        viewModel?.isLoading.bind { [weak self] isLoading in
            guard let self = self else { return }
            self.setupAccessibilityOrder(isLoading: isLoading)
            self.configureShimmerView(isLoading: isLoading)
        }
    }

    private func configureShimmerView(isLoading: Bool) {
        guard let views = shimmerView?.subviews else { return }
        views.forEach { view in
            if view is UIStackView {
                configureShimmerSubviews(of: view, loadingStatus: isLoading)
            } else {
                view.backgroundColor = .white
                isLoading ? view.startShimmer(withConfiguration: ShimmerConfiguration(frame: CGSize(width: view.bounds.width, height: view.bounds.height))) : view.stopShimmer()
            }
        }

        shimmerView?.isHidden = !isLoading
        paymentBarView?.isHidden = isLoading
    }

    private func configureShimmerSubviews(of view: UIView, loadingStatus: Bool) {
        let stackSubviews = view.subviews
        stackSubviews.forEach { subView in
            subView.backgroundColor = .white
            let spaceToReduce: CGFloat = (Constants.numberOfSpacesBetweenShimmers * Constants.spacesBetweenShimmers / Constants.numberOfShimmersInStack)
            let width = ((UIScreen.main.bounds.width - Constants.totalSizeOfMarginView) / Constants.numberOfShimmersInStack) - spaceToReduce
            loadingStatus ? subView.startShimmer(withConfiguration: ShimmerConfiguration(frame: CGSize(width: width, height: subView.bounds.height))) : subView.stopShimmer()
        }
    }

    private func setupAccessibilityOrder(isLoading: Bool) {
        if isLoading {
            guard let shimmerViewElement = shimmerView else { return }
            accessibilityElements = [shimmerViewElement]
        } else {
            guard let paymentBarViewElement = paymentBarView else { return }
            accessibilityElements = [paymentBarViewElement]
        }
    }
}
