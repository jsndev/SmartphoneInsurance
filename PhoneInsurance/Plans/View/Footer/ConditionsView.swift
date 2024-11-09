//
//  ConditionsView.swift
//  Smartphone
//
//  Created by Jeff on 08/11/24.
//

import DesignSystem
import SnapKit

final class ConditionsView: UIView {
    
    // MARK: - Views

    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.dataDetectorTypes = .link
        textView.delegate = self
        textView.linkTextAttributes = [
            .foregroundColor: UIColor.portoSeguros100,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        textView.backgroundColor = .white
        return textView
    }()
    
    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)
        buildViewHierarchy()
        buildViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods

    func configure(with description: String, hyperlink: String, linkURL: String) {
        let attributedString = NSMutableAttributedString(
            string: description,
            attributes: [
                .foregroundColor: UIColor.black60,
                .font: UIFont.label(.regular),
                
            ]
        )
        if let linkRange = description.range(of: hyperlink) {
            let nsRange = NSRange(linkRange, in: description)
            attributedString.addAttribute(.link, value: linkURL, range: nsRange)
        }
        textView.attributedText = attributedString
    }


    // MARK: - Private Methods

    private func buildViewHierarchy() {
        addSubview(textView)
    }
    
    private func buildViewConstraints() {
        textView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension ConditionsView: UITextViewDelegate {
    // MARK: - UITextViewDelegate
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}
