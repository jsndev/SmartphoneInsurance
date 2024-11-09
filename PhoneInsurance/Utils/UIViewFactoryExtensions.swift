//
//  UIViewFactoryExtensions.swift
//  Smartphone
//
//  Created by Jeff on 07/11/24.
//

import DesignSystem

// MARK: - Helper Methods

extension UILabel {
    static func makeLabel(font: UIFont, numberOfLines: Int) -> UILabel {
        let label = UILabel()
        label.font = font
        label.numberOfLines = numberOfLines
        return label
    }

    static func makeIconLabel(icon: String? = nil, size: CGFloat) -> UILabel {
        let label = UILabel()
        label.font = UIFont(name: FontNames.iconsPorto, size: size)
        label.textAlignment = .left
        label.text = icon
        return label
    }
    
    func apply(_ closure: (UILabel) -> Void) -> UILabel {
        closure(self)
        return self
    }
}

extension UIStackView {
    static func makeStackView(axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.spacing = spacing
        stackView.alignment = .center
        return stackView
    }
    
    func apply(_ closure: (UIStackView) -> Void) -> UIStackView {
        closure(self)
        return self
    }

}

extension UIButton {
    static func makeButton(title: String, titleColor: UIColor, backgroundColor: UIColor = .clear, cornerRadius: CGFloat = 0) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = backgroundColor
        button.layer.cornerRadius = cornerRadius
        return button
    }

    func apply(_ closure: (UIButton) -> Void) -> UIButton {
        closure(self)
        return self
    }
}
