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
        static let heightNavigation: CGFloat = 60
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
        static let portoButtonShimmerViewTag: Int = 26050011102024
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
        stackView.translatesAutoresizingMaskIntoConstraints = false
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
            vertical: .custom(
                mainColor: .white,
                highlightColor: Constants.backgroundColor,
                textBorderColor: Constants.backgroundColor
            ),
            type: .primary,
            style: .tall
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
        backgroundColor = Constants.backgroundColor
        setupWithDummyViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        model = nil
        buttonAction = nil
        dismissAction = nil
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
    }
    
    private func setupHierarchy() {
        addSubview(navigationBar)
        addSubview(scrollView)
        addSubview(continueButton)
        scrollView.addSubview(mainStack)
        let spaceView = UIView()
        mainStack.addArrangedSubview(spaceView)
        mainStack.setCustomSpacing(Constants.largerSpacing, after: spaceView)
        mainStack.addArrangedSubview(mainTitle)
        mainStack.setCustomSpacing(Constants.largerSpacing, after: mainTitle)
        
        model?.cellPhoneBenefits?.forEach { benefitsResponse in
            guard let iconCode = benefitsResponse.icon else { return }
            let benefitsCardView = IconTextCardView(
                iconCode: iconCode,
                titleText: benefitsResponse.title ?? String(),
                descriptionText: benefitsResponse.description ?? String()
            )
            mainStack.addArrangedSubview(benefitsCardView)
        }
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
            make.bottom.equalTo(continueButton.snp.top).offset(-Constants.stackViewButtonSpacing)
        }
        
        mainStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Constants.largerSpacing)
            make.width.equalToSuperview().inset(Constants.largerSpacing)
        }
        
        continueButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.defaultSpacing)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-Constants.largerSpacing)
        }
    }
    
    private func resetComponents() {
        continueButton.removeFromSuperview()
        
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
        mainTitle.startShimmerAsLabels()
        startPortoButtonCustomShimmer()
        
        mainStack.arrangedSubviews.forEach { view in
            guard let benefitCardView = view as? IconTextCardView else { return }
            benefitCardView.startShimmerCard()
        }
    }
    
    func stopShimmerView() {
        mainTitle.stopShimmerAsLabels()
        stopPortoButtonCustomShimmer()
        
        mainStack.arrangedSubviews.forEach { view in
            guard let benefitCardView = view as? IconTextCardView else { return }
            benefitCardView.stopShimmerCard()
        }
    }
    
    private func startPortoButtonCustomShimmer() {
        removeTagSubview()
        let shimmerView = UIView.createEmptyView()
        shimmerView.backgroundColor = Constants.backgroundColor
        shimmerView.tag = Constants.portoButtonShimmerViewTag
        continueButton.addSubview(shimmerView)
        shimmerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        shimmerView.shimmer.startShimmer()
    }
    
    private func stopPortoButtonCustomShimmer() {
        removeTagSubview()
    }
    
    private func removeTagSubview() {
        guard let shimmerView = continueButton.viewWithTag(Constants.portoButtonShimmerViewTag) else { return }
        shimmerView.removeFromSuperview()
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

// MARK: - Dummy Views for Shimmer

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
            mainTitle: String(),
            cellPhoneBenefits: benefits,
            buttonData: nil,
            loadingComponents: nil,
            progressDescriptions: nil
        )
    }
}
