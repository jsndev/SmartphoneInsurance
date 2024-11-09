//
//  ShimmerAsLabelsView.swift
//  Smartphone
//
//  Created by Dennis Torres on 10/10/24.
//

import DesignSystem
import UIKit

class ShimmerAsLabelsView: UIView {
    
    // MARK: - Model
    
    struct Model {
        var length: LabelsLength
        var spacingBetween: CGFloat
        var textSize: CGFloat
        var alignment: NSTextAlignment
        var contentWidth: CGFloat?
        
        public init(
            length: LabelsLength = .similarLength,
            spacingBetween: CGFloat? = nil,
            textSize: CGFloat? = nil,
            alignment: NSTextAlignment = .left,
            contentWidth: CGFloat? = nil
        ) {
            self.length = length
            self.spacingBetween = spacingBetween ?? Constants.defaultSpacing
            self.textSize = textSize ?? Constants.defaultTextSize
            self.alignment = alignment
            self.contentWidth = contentWidth
        }
    }
    
    // MARK: - Enum
    
    enum LabelsLength {
        case topLabelLong
        case similarLength
        case bothEqual
        
        var value: CGFloat {
            switch self {
            case .topLabelLong:
                return Constants.topLabelLongValue
            case .similarLength:
                return Constants.similarLengthValue
            case .bothEqual:
                return .zero
            }
        }
        
        var widthMultiplier: CGFloat {
            switch self {
            case .topLabelLong:
                return Constants.topLabelLongMultiplier
            case .similarLength:
                return Constants.similarLengthMultiplier
            case .bothEqual:
                return Constants.equalMultiplier
            }
        }
    }
    
    private enum Constants {
        static let defaultSpacing: CGFloat = .spacing(.small)
        static let defaultTextSize: CGFloat = FontSizeDS.title4.rawValue
        static let numOfLines: Int = 1
        static let centerDivisor: CGFloat = 2
        static let shimmerText: String = "Lorem ipsum dolor sit"
        static let similarLengthValue: CGFloat = 24
        static let topLabelLongValue: CGFloat = 86
        static let similarLengthMultiplier: CGFloat = 0.9
        static let topLabelLongMultiplier: CGFloat = 0.672
        static let equalMultiplier: CGFloat = 1
    }
    
    // MARK: - Subviews
    
    private lazy var firstLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = model.alignment
        label.text = Constants.shimmerText
        label.font = .systemFont(ofSize: model.textSize)
        label.numberOfLines = Constants.numOfLines
        return label
    }()
    
    private lazy var secondLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = model.alignment
        label.text = Constants.shimmerText
        label.font = .systemFont(ofSize: model.textSize)
        label.numberOfLines = Constants.numOfLines
        return label
    }()
    
    // MARK: - Private properties
    
    private var model: Model
    
    // MARK: - Init
    
    init(with model: Model = Model()) {
        self.model = model
        super.init(frame: .zero)
        setupHierarchy()
        setupConstraints()
        startShimmerView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

extension ShimmerAsLabelsView {
    private func setupHierarchy() {
        isHidden = false
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(firstLabel)
        addSubview(secondLabel)
    }
    
    private func setupConstraints() {
        secondLabel.snp.makeConstraints { make in
            make.top.equalTo(firstLabel.snp.bottom).inset(-model.spacingBetween)
        }
        
        guard let contentWidth = model.contentWidth else {
            setupSidesSpacing(with: firstLabel)
            setupSidesSpacing(with: secondLabel, alignmentView: model.alignment)
            return
        }
        setupSidesSpacing(with: firstLabel, contentWidth: contentWidth)
        setupSidesSpacing(with: secondLabel, alignmentView: model.alignment, contentWidth: contentWidth)
    }
    
    private func setupSidesSpacing(
        with labelView: UIView,
        alignmentView: NSTextAlignment = .natural
    ) {
        labelView.snp.makeConstraints { make in
            make.height.equalTo(model.textSize)
            
            labelView == firstLabel
            ? make.top.equalToSuperview()
            : make.bottom.equalToSuperview()
            
            switch alignmentView {
            case .left:
                make.trailing.equalToSuperview().offset(-model.length.value)
                make.leading.equalToSuperview()
            case .center:
                let spacingValue = model.length.value/Constants.centerDivisor
                make.leading.equalToSuperview().offset(spacingValue)
                make.trailing.equalToSuperview().offset(-spacingValue)
            case .right:
                make.leading.equalToSuperview().offset(model.length.value)
                make.trailing.equalToSuperview()
            @unknown
            default:
                make.leading.trailing.equalToSuperview()
            }
        }
    }
    
    private func setupSidesSpacing(
        with labelView: UIView,
        alignmentView: NSTextAlignment = .natural,
        contentWidth: CGFloat
    ) {
        labelView.snp.makeConstraints { make in
            make.height.equalTo(model.textSize)
            
            labelView == firstLabel
            ? make.top.equalToSuperview()
            : make.bottom.equalToSuperview()
            
            switch alignmentView {
            case .left:
                make.leading.equalToSuperview()
                make.width.equalTo(contentWidth * model.length.widthMultiplier)
            case .center:
                make.leading.trailing.equalToSuperview()
                make.width.equalTo((contentWidth * model.length.widthMultiplier * Constants.centerDivisor))
            case .right:
                make.trailing.equalToSuperview()
                make.width.equalTo(contentWidth * model.length.widthMultiplier)
            @unknown
            default:
                make.leading.trailing.equalToSuperview()
                make.width.equalTo(contentWidth)
            }
        }
    }
    
    private func startShimmerView() {
        firstLabel.isHidden = false
        secondLabel.isHidden = false
        firstLabel.shimmer.startShimmer()
        secondLabel.shimmer.startShimmer()
    }
}

// MARK: - Public Shimmer Extension

extension UIView {
    func startShimmerAsLabels(config: ShimmerAsLabelsView.Model = ShimmerAsLabelsView.Model()) {
        addSubview(ShimmerAsLabelsView(with: config), applyConstraints: true)
    }
    
    func stopShimmerAsLabels() {
        subviews.forEach { subview in
            guard let shimmerView = subview as? ShimmerAsLabelsView else { return }
            shimmerView.removeFromSuperview()
        }
    }
}

