//
//  InsuranceShortcutsView.swift
//  Smartphone
//
//  Created by Hugo Hernany da Silva Cabral on 06/04/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Components
import UIKit

class InsuranceShortcutsView: UIView {
    // MARK: - Private Properties

    private var viewModel: InsuranceShortcutsViewModelProtocol?
    private var countNumberOfViews: Int = .zero
    private var maxNumberOfViews: Int = 3

    // MARK: - Private Constants

    private let cornerRadius: CGFloat = 4
    private let shortcutMoreWidth: CGFloat = 56
    private let shortcutHeight: CGFloat = 72

    // MARK: - IBOutlets

    @IBOutlet private weak var shortcutsTitle: UILabel? {
        didSet {
            shortcutsTitle?.text = LocalizableBundle.smartphoneShortcutsTitle.localize
        }
    }

    @IBOutlet private weak var shortcutsStackView: UIStackView?
    @IBOutlet private weak var containerView: UIView?
    @IBOutlet private weak var separatorView: UIView?

    // MARK: - Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)

        loadFromXib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        loadFromXib()
    }

    // MARK: - Public functions

    public func setup(viewModel: InsuranceShortcutsViewModelProtocol?) {
        self.viewModel = viewModel
        createViews()
        configureContainer()
        setupAccessibilityOrder()
    }

    @objc
    func didActionButtonTap(_ sender: UITapGestureRecognizer) {
        guard let viewTag = sender.view?.tag else { return }
        guard let shortcut = viewModel?.shortcutsModel.shortcutItems[viewTag] else { return }
        viewModel?.smartphoneShortcutAction(model: shortcut)
    }

    // MARK: - Private functions

    private func configureContainer() {
        let corners: CACornerMask = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        containerView?.layer.maskedCorners = corners
        containerView?.layer.masksToBounds = true
        containerView?.layer.cornerRadius = cornerRadius
    }

    private func createViews() {
        guard let viewModel = viewModel else { return }

        separatorView?.isHidden = viewModel.showSeparatorView
        
        viewModel.shortcutsModel.shortcutItems.forEach { item in
            if shortcutsStackView?.arrangedSubviews.count == maxNumberOfViews {
                return
            }

            let view = ShortcutItemView()
            view.setup(withViewModel: item)
            shortcutsStackView?.addArrangedSubview(view)
            shortcutsStackView?.distribution = .fillEqually
            view.tag = countNumberOfViews
            view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didActionButtonTap(_:))))
            countNumberOfViews += 1
            
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: shortcutHeight).isActive = true
        }
    }

    private func setupAccessibilityOrder() {
        guard let shortcutTitleElement = shortcutsTitle, let shortcutsStackElement = shortcutsStackView?.subviews else { return }
        accessibilityElements = [shortcutTitleElement, shortcutsStackElement]
    }
}
