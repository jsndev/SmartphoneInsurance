//
//  SmartphoneInsuranceCrossSellView.swift
//  Smartphone
//
//  Created by Lucas Alcalde Bie da Silva on 26/03/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Components
import DesignSystem
import UIKit

class SmartphoneInsuranceCrossSellView: UIView {
    // MARK: - Constants

    private let cornerRadius: CGFloat = 4

    // MARK: - IBOutlets

    @IBOutlet private weak var iconWaitLabel: UILabel?
    @IBOutlet private weak var descriptionLabel: UILabel?
    @IBOutlet private weak var contentView: UIView?

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

    public func setup() {
        setupDescriptionLabel()
        setupIcon()
        setupContent()
    }

    // MARK: - Private functions

    private func setupIcon() {
        iconWaitLabel?.setIconFont(size: .size(.big))
        iconWaitLabel?.textColor = .brandColorPrimary
        iconWaitLabel?.isAccessibilityElement = false
        iconWaitLabel?.text = Icons.wait.codeToIcon
    }

    private func setupDescriptionLabel() {
        descriptionLabel?.font = UIFont(name: .bold, size: .medium)
        descriptionLabel?.textColor = .brandColorSecondary
        descriptionLabel?.textAlignment = .center
        descriptionLabel?.numberOfLines = .zero
        descriptionLabel?.text = LocalizableBundle.smartphoneCrossSellDescription.localize
    }

    private func setupContent() {
        contentView?.cornerRadius(cornerRadius)
    }
}
