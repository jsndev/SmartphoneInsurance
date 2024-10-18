//
//  SmartphoneInsuranceHeaderView.swift
//  Smartphone
//
//  Created by Hugo Hernany da Silva Cabral on 22/03/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Components
import Core
import UIKit

class SmartphoneInsuranceHeaderView: UIView {
    // MARK: - Constants

    private enum LayoutConstants {
        static let cornerRadius: CGFloat = 4
    }

    // MARK: - Properties

    private var insuranceHeaderViewModel: SmartphoneInsuranceHeaderViewModelProtocol?

    // MARK: - Outlets

    @IBOutlet private weak var containerView: UIView?
    @IBOutlet private weak var headerView: HeaderView?
    @IBOutlet private weak var separatorView: UIView?

    // MARK: - Overrides & Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        loadFromXib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        loadFromXib()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = false
        layer.masksToBounds = false
    }

    // MARK: - Methods

    public func setup(with viewModel: BaseViewModel?, isUnique: Bool) {
        guard let viewModel = viewModel as? SmartphoneInsuranceHeaderViewModel else { return }
        insuranceHeaderViewModel = viewModel

        setupHeaderView(with: viewModel.headerViewModel, isUnique: isUnique)
        setupSeparator()

        setupAccessibility()
    }

    private func setupHeaderView(with viewModel: HeaderViewModelProtocol?, isUnique: Bool) {
        guard let viewModel = viewModel else { return }
        headerView?.setup(withViewModel: viewModel, isUnique: isUnique)
        separatorView?.backgroundColor = .neutralColorGrey05
    }

    private func setupSeparator() {
        insuranceHeaderViewModel?.isExpanded.bind { [weak self] status in
            guard let status = status, let self = self else { return }

            if self.insuranceHeaderViewModel?.status == .pending {
                self.separatorView?.isHidden = !status
            } else {
                self.separatorView?.isHidden = true
            }

            self.setupCorners(isExpanded: status)
        }
    }

    private func setupCorners(isExpanded: Bool) {
        var corners: CACornerMask = []
        if isExpanded {
            corners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        } else {
            corners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        containerView?.layer.maskedCorners = corners
        containerView?.layer.masksToBounds = true
        containerView?.layer.cornerRadius = LayoutConstants.cornerRadius
    }

    private func setupAccessibility() {
        headerView?.isAccessibilityElement = true
        isAccessibilityElement = false

        insuranceHeaderViewModel?.headerViewModel?.accessibility.bind { [weak self] values in
            self?.headerView?.accessibilityTraits = values?.traits ?? .none
            self?.headerView?.accessibilityLabel = values?.label
        }

        guard let headerViewElement = headerView else { return }
        accessibilityElements = [headerViewElement]
    }
}
