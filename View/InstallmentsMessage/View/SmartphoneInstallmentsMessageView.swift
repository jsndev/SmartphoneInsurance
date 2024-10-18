//
//  SmartphoneInstallmentsMessageView.swift
//  Smartphone
//
//  Created by Hugo Hernany da Silva Cabral on 12/05/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Components
import Core
import UIKit

final class SmartphoneInstallmentsMessageView: UIView {
    // MARK: - Constants

    private enum Constants {
        static let totalSizeOfMarginView: CGFloat = 80
    }

    // MARK: - Outlets

    @IBOutlet private weak var shimmerView: UIView? {
        didSet {
            shimmerView?.accessibilityLabel = AccessibilityLocalizableBundle.shimmerLoading.accessibilityLocalize
        }
    }

    @IBOutlet private weak var labelMessageView: LabelMessageView?

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

    func setup(with viewModel: BaseViewModel?, shouldShimmerize: Bool) {
        configureShimmerView(isLoading: shouldShimmerize)

        setupAccessibilityOrder(isLoading: shouldShimmerize)

        guard let viewModel = viewModel as? SmartphoneInstallmentsMessageViewModelProtocol else { return }

        let properties = viewModel.properties
        let labelMessageType: LabelMessageView.LabelType
        var buttonProperties: LabelMessageButtonProperties?

        switch properties.messageData.type {
        case .policyPaidOff, .nextInstallment, .currentInstallmentAwaitingPayment:
            labelMessageType = .neutral
        case .pendingInstallments:
            labelMessageType = .warning
        }

        if let buttonTitle = properties.buttonTitle, let buttonAction = properties.buttonAction {
            buttonProperties = .init(title: buttonTitle, action: buttonAction)
        }

        labelMessageView?.viewModel = LabelMessageViewModel(
            type: labelMessageType,
            icon: properties.messageData.type.icon,
            message: properties.messageData.attributedMessage,
            title: properties.title,
            buttonProperties: buttonProperties
        )
        labelMessageView?.viewModel?.accessibility.value = viewModel.accessibilityViewModel
    }

    // MARK: - Private Methods

    private func configureShimmerView(isLoading: Bool) {
        guard let views = shimmerView?.subviews else { return }
        if let subView = views.first {
            subView.backgroundColor = .white
            isLoading ? subView.startShimmer(withConfiguration: ShimmerConfiguration(frame: CGSize(width: UIScreen.main.bounds.width - Constants.totalSizeOfMarginView, height: subView.bounds.height))) : subView.stopShimmer()
        }

        shimmerView?.isHidden = !isLoading
        labelMessageView?.isHidden = isLoading
    }

    private func setupAccessibilityOrder(isLoading: Bool) {
        if isLoading {
            guard let shimmerViewElement = shimmerView else { return }
            accessibilityElements = [shimmerViewElement]
        } else {
            guard let labelMessageViewElement = labelMessageView else { return }
            accessibilityElements = [labelMessageViewElement]
        }
    }
}
