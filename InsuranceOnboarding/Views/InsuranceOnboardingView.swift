//
//  InsuranceOnboardingView.swift
//  Smartphone
//
//  Created by Dennis Torres on 02/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

import DesignSystem
import UIKit

class InsuranceOnboardingView: UIView {
    
    // MARK: - Enum
    
    private enum Constants {
        static let heightNavigation = 60
        static let backgroundColor: UIColor = .portoSeguros100
        static let labelsColor: UIColor = .white
        static let componentsSpacing: CGFloat = .spacing(.large)
        static let defaultSpacing: CGFloat = .spacing(.small)
        static let largerSpacing: CGFloat = .spacing(.medium)
        static let stackViewButtonSpacing: CGFloat = .spacing(.giga)
        static let shimmerText: String = "Lorem ipsum dolor sit"
        static let defaultIconCode = "ebb1"
        static let numOfDummyViews: Int = 4
        static let dummyTextRange: Int = 12
        static let limitScrollOffSet: CGFloat = 50
        static let shouldLimitScroll = false
    }
    
    // MARK: - Subviews
    
    private lazy var navigationBar: PortoNavigationView = {
        let navViewModel = PortoNavigationViewModel(
            style: .holding(variation: .color100)
        )
        let navBar = PortoNavigationView.instantiate(viewModel: navViewModel) { [weak self] _ in
            self?.dismissAction?()
        }
        return navBar
    }()
    
    private lazy var mainTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Constants.labelsColor
        label.font = .title1()
        label.numberOfLines = .zero
        label.textAlignment = .left
        return label
    }()
    
    private lazy var mainStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.componentsSpacing
        return stackView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollV = UIScrollView()
        scrollV.translatesAutoresizingMaskIntoConstraints = false
        scrollV.clipsToBounds = true
        scrollV.showsVerticalScrollIndicator = false
        scrollV.delegate = self
        return scrollV
    }()
    
    private lazy var continueButton: PortoButton = {
        let buttonViewModel = PortoButtonViewModel(
            type: .primary,
            style: .tall,
            whiteMode: true
        )
        return PortoButton.instantiate(viewModel: buttonViewModel) { [weak self] _ in
            self?.buttonAction?()
        }
    }()
    
    // MARK: - Internal properties
    
    var dismissAction: (() -> Void)?
    var buttonAction: (() -> Void)?
    
    // MARK: - Private properties
    
    private var model: BenefitsResponse?
    
    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        model = nil
        buttonAction = nil
    }
}

// MARK: - Internal methods

extension InsuranceOnboardingView {
    func setup(with model: BenefitsResponse) {
        self.model = model
        
        resetComponents()
        setupElements()
        setupHierarchy()
        setupConstraints()
    }
    
    func setupWithDummyViews() {
        let dummyModel = BenefitsResponse.getDummyViews(
            dummyIcon: Constants.defaultIconCode,
            dummyText: Constants.shimmerText,
            breaklineRange: Constants.dummyTextRange,
            descriptionRange: Constants.dummyTextRange,
            numOfViews: Constants.numOfDummyViews
        )
        setup(with: dummyModel)
    }
}

// MARK: - Private methods

extension InsuranceOnboardingView {
    private func setupElements() {
        mainTitle.attributedText = .getTextUsingBBCode(fullText: model?.mainTitle, textSize: FontSizeDS.title1.rawValue)
        continueButton.setTitle(model?.buttonData?.title, for: .normal)
        continueButton.setTitleColor(Constants.backgroundColor, for: .normal)
    }
    
    private func setupHierarchy() {
        addSubview(navigationBar)
        addSubview(scrollView)
        scrollView.addSubview(mainStack)
        let spaceView = UIView()
        mainStack.addArrangedSubview(spaceView)
        mainStack.setCustomSpacing(Constants.largerSpacing, after: spaceView)
        mainStack.addArrangedSubview(mainTitle)
        
        model?.cellPhoneBenefits?.forEach { benefitsResponse in
            guard let iconCode = benefitsResponse.icon else { return }
            let benefitsCardView = IconTextCardView(
                iconCode: iconCode,
                titleText: benefitsResponse.title ?? String(),
                descriptionText: benefitsResponse.description ?? String()
            )
            mainStack.addArrangedSubview(benefitsCardView)
        }
        scrollView.addSubview(continueButton)
    }
    
    private func setupConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(Constants.heightNavigation)
        }
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.width.left.right.bottom.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
        
        mainStack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Constants.largerSpacing)
//            make.left.equalToSuperview().inset(Constants.largerSpacing)
//            make.right.equalToSuperview().inset(-Constants.largerSpacing)
            make.width.equalToSuperview().inset(Constants.largerSpacing)
            make.bottom.lessThanOrEqualTo(continueButton.snp.top).offset(-Constants.stackViewButtonSpacing)//.priority(.high)
        }
        
        continueButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.defaultSpacing)
//            make.right.equalToSuperview().inset(Constants.defaultSpacing)
            make.bottom.equalToSuperview().offset(-Constants.largerSpacing)
        }
        
        
    }
    
    private func resetComponents() {
        mainStack.arrangedSubviews.forEach { view in
            mainStack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        scrollView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        scrollView.removeFromSuperview()
        
        scrollView.snp.removeConstraints()
        mainStack.snp.removeConstraints()
    }
}

// MARK: - Shimmer

extension InsuranceOnboardingView {
    func startShimmerView() {
//        mainTitle.text = .addBreakLineAt(
//            Constants.shimmerText,
//            breaklineRange: 12
//        )
//        
//        mainTitle.startShimmer()
//        continueButton.startPortoShimmer()
        continueButton.isLoading = true
        
        mainStack.arrangedSubviews.forEach { view in
            guard let benefitCardView = view as? IconTextCardView else {
                view.startShimmer()
                return
            }
            benefitCardView.startShimmerCard()
        }
    }
    
    func stopShimmerView() {
        //mainTitle.attributedText = .getTextUsingBBCode(fullText: model?.mainTitle, textSize: FontSizeDS.title1.rawValue)
        
        mainTitle.stopShimmer()
//        continueButton.stopPortoShimmer()
        continueButton.isLoading = false
        
        mainStack.arrangedSubviews.forEach { view in
            guard let benefitCardView = view as? IconTextCardView else { return }
            benefitCardView.stopShimmerCard()
        }
    }
}

// MARK: - UIScrollViewDelegate

extension InsuranceOnboardingView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard Constants.shouldLimitScroll else { return }
        
        if scrollView.contentOffset.y < -Constants.limitScrollOffSet {
            scrollView.contentOffset.y = .zero
        }
        
        let maxOffset = scrollView.contentSize.height - scrollView.bounds.height
        if scrollView.contentOffset.y > maxOffset + Constants.limitScrollOffSet {
            scrollView.contentOffset.y = maxOffset
        }
    }
}

// MARK: - Dummy Views

extension BenefitsResponse {
    static func getDummyViews(
        dummyIcon: String,
        dummyText: String,
        breaklineRange: Int,
        descriptionRange: Int,
        numOfViews: Int
    ) -> BenefitsResponse {
        let defaultIcon = "ebb1"
        let benefits = [
            CellPhoneBenefitsResponse(
                icon: defaultIcon,
                title: dummyText,
                description: String(dummyText.prefix(descriptionRange))
            ),
            CellPhoneBenefitsResponse(
                icon: defaultIcon,
                title: dummyText,
                description: String(dummyText.prefix(descriptionRange))
            ),
            CellPhoneBenefitsResponse(
                icon: defaultIcon,
                title: dummyText,
                description: String(dummyText.prefix(descriptionRange))
            ),
            CellPhoneBenefitsResponse(
                icon: defaultIcon,
                title: dummyText,
                description: String(dummyText.prefix(descriptionRange))
            )
        ]
        return BenefitsResponse(
            mainTitle: .addBreakLineAt(
                dummyText,
                breaklineRange: breaklineRange
            ),
            cellPhoneBenefits: benefits,
            buttonData: nil,
            loadingComponents: nil,
            progressDescription: nil
        )
    }
}

extension String {
    static func addBreakLineAt(_ text: String, breaklineRange: Int) -> String {
        guard text.count >= breaklineRange else { return text }
        
        let index = text.index(text.startIndex, offsetBy: breaklineRange)
        
        let firstPart = text[..<index]
        let secondPart = text[index...]
        
        return "\(firstPart)\n\(secondPart)"
    }
}
