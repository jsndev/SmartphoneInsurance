//
//  SmartphoneListErrorSectionModel.swift
//  Smartphone
//
//  Created by Hugo Hernany da Silva Cabral on 06/05/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Components
import Core

/// Section model related to present error view
struct SmartphoneListErrorSectionModel: ExpandableTableViewCellModelProtocol {
    var headerView: UIView
    var contentViews: [UIView]
    var isExpanded: Bool

    init(buttonAction: (() -> Void)? = nil, errorCount: Int, message: String = String(), topConstraint: CGFloat? = nil, bottomConstraint: CGFloat? = nil, roundedCorners: Bool = true) {
        let errorMessage = message.isEmpty ? LocalizableBundle.smartphonePendingValidationErrorMessage.localize : message

        let errorAttempts = ErrorAttemptsModel(message: errorMessage, button: LocalizableBundle.smartphoneErrorRefreshButtonTitle.localize, action: buttonAction)
        let errorLastAttemptModel = ErrorLastAttemptModel(icon: nil, message: errorMessage)
        let errorViewModel = ErrorViewModel(attempts: errorAttempts, lastAttempt: errorLastAttemptModel)
        errorViewModel.isMaxAttemptsReached.value = errorCount == ErrorCount.third.rawValue

        let errorView = InspectionListErrorView()
        errorView.setup(viewModel: errorViewModel, topConstraint: topConstraint, bottomConstraint: bottomConstraint, roundedCorners: roundedCorners, action: buttonAction)

        headerView = errorView
        contentViews = []
        isExpanded = false
    }
}
