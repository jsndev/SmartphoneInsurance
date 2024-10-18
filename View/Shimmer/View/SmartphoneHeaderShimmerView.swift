//
//  SmartphoneHeaderShimmerView.swift
//  Smartphone
//
//  Created by Hugo Hernany da Silva Cabral on 10/03/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Components
import Core
import UIKit

class SmartphoneHeaderShimmerView: UIView {
    // MARK: - Constants

    private let shadowColor: UIColor = .black
    private let shadowOpacity: Float = 0.35
    private let shadowRadius: CGFloat = 4
    private let shadowOffset = CGSize(width: 0, height: 0)
    private var shimmerViewModel: SmartphoneHeaderShimmerViewModelProtocol?
    private let cornerRadius: CGFloat = 4.0

    // MARK: - Outlets

    @IBOutlet private weak var containerView: UIView?
    @IBOutlet private var shimmerViews: [UIView]?

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
        layer.masksToBounds = true
        layer.cornerRadius = cornerRadius

        applyShadow(view: containerView)
    }

    // MARK: - Public Functions

    func setup(withViewModel viewModel: SmartphoneHeaderShimmerViewModelProtocol = SmartphoneHeaderShimmerViewModel(isLoading: true)) {
        shimmerViewModel = viewModel
        configureShimmerView(isLoading: viewModel.isLoading.value)
    }

    // MARK: - Private functions

    private func configureShimmerView(isLoading: Bool) {
        guard let views = shimmerViews else { return }
        views.forEach { view in
            view.backgroundColor = .white

            isLoading
                ? view.startShimmer(withConfiguration: ShimmerConfiguration(frame: CGSize(width: view.bounds.width, height: view.bounds.height)))
                : view.stopShimmer()
        }
    }

    private func applyShadow(view: UIView?) {
        view?.layer.shadowColor = shadowColor.cgColor
        view?.layer.shadowOpacity = shadowOpacity
        view?.layer.shadowRadius = shadowRadius
        view?.layer.shadowOffset = shadowOffset
        view?.layer.cornerRadius = cornerRadius
    }
}
