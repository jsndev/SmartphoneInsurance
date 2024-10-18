//
//  InsuranceRemainingDaysView.swift
//  Smartphone
//
//  Created by Hugo Hernany da Silva Cabral on 08/04/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Core
import UIKit

class InsuranceRemainingDaysView: UIView {
    // MARK: - Constants

    private let singleDay: Int = 1

    // MARK: - Private Properties

    private var model: SmartphoneInsuranceData?

    // MARK: - Outlets

    @IBOutlet private weak var titleLabel: UILabel? {
        didSet {
            titleLabel?.textColor = .neutralColorGrey01
        }
    }

    // MARK: - Overrides & Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)

        loadFromXib()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        loadFromXib()
    }

    // MARK: - Instantiate

    public func setup(with model: SmartphoneInsuranceData?) {
        self.model = model
        configureView()
        setupAccessibilityOrder()
    }

    // MARK: - Private Methods

    private func configureView() {
        isUserInteractionEnabled = false // prevents VoiceOver to present cell as 'selected'

        guard let remainingDays = model?.coverage else { return }

        let attributedText = NSMutableAttributedString()
        attributedText.append(.init(string: LocalizableBundle.coveredFor.localize, attributes: [.font: UIFont(name: .regular, size: .small) as Any]))
        attributedText.append(.init(string: "\(remainingDays)", attributes: [.font: UIFont(name: .bold, size: .small) as Any]))

        let dayString = LocalizableBundle.day.localize
        let daysString = LocalizableBundle.days.localize
        if remainingDays == singleDay {
            attributedText.append(.init(string: dayString, attributes: [.font: UIFont(name: .regular, size: .small) as Any]))
        } else {
            attributedText.append(.init(string: daysString, attributes: [.font: UIFont(name: .regular, size: .small) as Any]))
        }

        titleLabel?.accessibilityLabel = attributedText.string
        titleLabel?.attributedText = attributedText
    }

    private func setupAccessibilityOrder() {
        guard let titleLabelElement = titleLabel else { return }
        accessibilityElements = [titleLabelElement]
    }
}
