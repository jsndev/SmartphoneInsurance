//
//  PhoneInsuranceRequestingView.swift
//  Smartphone
//
//  Created by Dennis Torres on 03/10/24.
//  Copyright © 2024 Porto Seguro. All rights reserved.
//

import DesignSystem
import UIKit

class PhoneInsuranceRequestingView: UIView {

    // MARK: - Enum
    
    private enum Constants {
        static let defaultSpacing: CGFloat = .spacing(.small)
        static let largerSpacing: CGFloat = .spacing(.medium)
        static let componentsSpacing: CGFloat = .spacing(.large)
        static let progressVerticalSpacing: CGFloat = 21
        static let gradientTopHeight: CGFloat = 360
        static let gradientBottomHeight: CGFloat = .size(.xLarger)
        static let progressDescHeight: CGFloat = 28
        static let backgroundColor: UIColor = .portoSeguros100
        static let startAlphaGradient: CGFloat = .zero
        static let endAlphaGradient: CGFloat = 1
        static let loadingDescNumOfLines: Int = 1
        static let initialLoadingTime: Float = .zero
        static let defaultLoadingTime: Float = 30
        static let currentIndexRange: Int = 2
        static let appearingAnimation: CGFloat = 0.3
        static let disappearingAnimation: CGFloat = 0.7
        static let gradientLocations: [NSNumber] = [0.0, 0.3, 0.6, 0.8, 0.9, 1.0]
        static let gradientColors: [UIColor] = [
            backgroundColor.withAlphaComponent(1),
            backgroundColor.withAlphaComponent(0.85),
            backgroundColor.withAlphaComponent(0.6),
            backgroundColor.withAlphaComponent(0.4),
            backgroundColor.withAlphaComponent(0.25),
            backgroundColor.withAlphaComponent(0.1),
            backgroundColor.withAlphaComponent(0.045),
            .clear
        ]
    }
    
    // MARK: - Subviews
    
    private lazy var mainStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constants.componentsSpacing
        stackView.isUserInteractionEnabled = false
        return stackView
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollV = UIScrollView()
        scrollV.translatesAutoresizingMaskIntoConstraints = false
        scrollV.clipsToBounds = true
        scrollV.showsVerticalScrollIndicator = false
        scrollV.isUserInteractionEnabled = false
        return scrollV
    }()
    
    private lazy var emptyTopView: UIView = {
        let topView: UIView = .createEmptyView()
        topView.backgroundColor = Constants.backgroundColor
        return topView
    }()
    
    private lazy var gradientTopView: UIView = {
        let gView: UIView = .createEmptyView()
        gView.applyGradient(
            colors: Constants.gradientColors,
            locations: Constants.gradientLocations,
            startPoint: CGPoint(x: 0.5, y: 0.0),
            endPoint: CGPoint(x: 0.5, y: 0.84)
        )
        return gView
    }()
    
    private lazy var gradientBottomView: UIView = {
        let gView: UIView = .createEmptyView()
        gView.applyGradient(
            colors: Constants.gradientColors.reversed(),
            locations: Constants.gradientLocations,
            startPoint: CGPoint(x: 0.5, y: 0.0),
            endPoint: CGPoint(x: 0.5, y: 0.75)
        )
        return gView
    }()
    
    private lazy var progressDescription: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .title5()
        label.numberOfLines = Constants.loadingDescNumOfLines
        label.textAlignment = .left
        return label
    }()
    
    public lazy var progressBar: PortoProgressBar = {
        let viewModel: PortoProgressBarViewModel = .getDefaultViewModel(
            totalValue: Constants.defaultLoadingTime,
            currentValue: Constants.initialLoadingTime
        )
        let progressBarView: PortoProgressBar = .instantiate(viewModel: viewModel)
        return progressBarView
    }()
    
    // MARK: - Private properties
    
    private var fadeinDuration: TimeInterval = .zero
    private var currentIndex: Int = .zero {
        didSet {
            timeoutChanged()
        }
    }
    private var loadingTime: Float? {
        didSet {
            timeoutChanged()
        }
    }
    private var model: LoadingProgressResponse?

    // MARK: - Init
    
    init() {
        super.init(frame: .zero)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for gradientView in [gradientTopView, gradientBottomView] {
            guard let gradientLayer = gradientView.layer.sublayers?.first as? CAGradientLayer
            else { return }
            gradientLayer.frame = gradientView.bounds
        }
    }
    
    deinit {
        model = nil
        loadingTime = nil
    }
}

// MARK: - Internal methods

extension PhoneInsuranceRequestingView {
    func setup(with model: LoadingProgressResponse?, loadingTime: Float) {
        self.model = model
        self.loadingTime = loadingTime
        
        resetComponents()
        setupElements()
        setupHierarchy()
        setupConstraints()
    }
    
    func uploadProgress(currentTime: Float, progressText: String? = nil) {
        let progressBarVM: PortoProgressBarViewModel = .getDefaultViewModel(
            totalValue: loadingTime ?? Constants.defaultLoadingTime,
            currentValue: currentTime
        )
        progressBar.setViewModel(viewModel: progressBarVM)
        
        if let progressText, progressText != progressDescription.text {
            progressDescription.text = progressText
        }
        
        if #available(iOS 17.0, *) {
            UIView.animate { layoutIfNeeded() }
        } else {
            layoutIfNeeded()
        }
    }
    
    func startFadeInTransitionCard() {
        currentIndex = 1
        transitionToNextBenefit()
    }
}

// MARK: - Private methods

extension PhoneInsuranceRequestingView {
    private func setupElements() {
        backgroundColor = Constants.backgroundColor
        
        progressDescription.text = model?.progress?.first
        
        let progressBarVM: PortoProgressBarViewModel = .getDefaultViewModel(
            totalValue: loadingTime ?? Constants.defaultLoadingTime,
            currentValue: Constants.initialLoadingTime
        )
        progressBar.setViewModel(viewModel: progressBarVM)
    }
    
    private func setupHierarchy() {
        addSubview(scrollView)
        addSubview(progressDescription)
        addSubview(progressBar)
        addSubview(gradientTopView)
        addSubview(emptyTopView)
        scrollView.addSubview(mainStack)
        
        model?.benefits?.forEach { benefitsResponse in
            guard let iconCode = benefitsResponse.icon else { return }
            
            creatingSpaceView()
            
            let benefitsCardView = IconTextCardView(
                iconCode: iconCode,
                titleText: benefitsResponse.title ?? String(),
                descriptionText: benefitsResponse.description ?? String()
            )
            mainStack.addArrangedSubview(benefitsCardView)
        }
        
        creatingSpaceView()
        
        bringSubviewToFront(gradientTopView)
        bringSubviewToFront(emptyTopView)
    }
    
    private func setupConstraints() {
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.width.left.right.bottom.equalToSuperview()
            make.bottom.equalTo(progressDescription.snp.top).offset(-Constants.largerSpacing)
        }
        
        mainStack.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(Constants.largerSpacing)
            make.width.equalToSuperview().inset(Constants.largerSpacing)
        }
        
        progressDescription.snp.makeConstraints { make in
            make.height.equalTo(Constants.progressDescHeight)
            make.leading.trailing.equalToSuperview().inset(Constants.defaultSpacing)
            make.bottom.equalTo(progressBar.snp.top).offset(-Constants.progressVerticalSpacing)
        }
        
        progressBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(Constants.defaultSpacing)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-Constants.componentsSpacing)
        }
        
        gradientTopView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(Constants.gradientTopHeight)
            make.bottom.equalTo(scrollView.snp.bottom)
        }
        
        emptyTopView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(gradientTopView.snp.top)
            make.top.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func resetComponents() {
        emptyTopView.removeFromSuperview()
        gradientTopView.removeFromSuperview()
        gradientBottomView.removeFromSuperview()
        
        mainStack.arrangedSubviews.forEach { view in
            mainStack.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
        
        scrollView.subviews.forEach { view in
            view.removeFromSuperview()
        }
        scrollView.removeFromSuperview()
        
        progressDescription.removeFromSuperview()
        progressBar.removeFromSuperview()
        
        emptyTopView.snp.removeConstraints()
        gradientTopView.snp.removeConstraints()
        gradientBottomView.snp.removeConstraints()
        scrollView.snp.removeConstraints()
        mainStack.snp.removeConstraints()
        progressDescription.snp.removeConstraints()
        progressBar.snp.removeConstraints()
    }
    
    private func creatingSpaceView() {
        let spaceView = UIView()
        spaceView.snp.makeConstraints { make in
            make.height.equalTo(UIScreen.getSize.height)
        }
        mainStack.addArrangedSubview(spaceView)
    }
    
    private func transitionToNextBenefit() {
        guard let benefitsCount = model?.benefits?.count,
              currentIndex <= benefitsCount * 2
        else { return }
        
        let appearingAnimation: TimeInterval = currentIndex > 1
        ? fadeinDuration * Constants.appearingAnimation
        : .zero
        
        let disappearingAnimation: TimeInterval = fadeinDuration * Constants.disappearingAnimation
        
        DispatchQueue.main.asyncAfter(deadline: .now() + appearingAnimation) {
            UIView.animate(withDuration: disappearingAnimation, animations: {
                self.scrollToNextView()
            }) { _ in
                self.currentIndex += 2
                self.transitionToNextBenefit()
            }
        }
    }
    
    private func scrollToNextView() {
        let nextView = mainStack.arrangedSubviews[currentIndex]
        let offsetY = nextView.frame.origin.y - scrollView.bounds.height + nextView.bounds.height
        scrollView.setContentOffset(CGPoint(x: .zero, y: offsetY), animated: false)
    }
    
    private func timeoutChanged() {
        guard let benefitsCount = model?.benefits?.count,
              let loadingTime = loadingTime
        else { return }
        fadeinDuration = CGFloat(loadingTime) / CGFloat(benefitsCount)
    }
}

// MARK: - ProgressBar ViewModel

extension PortoProgressBarViewModel {
    fileprivate static func getDefaultViewModel(totalValue: Float, currentValue: Float) -> PortoProgressBarViewModel {
        let progressInfo = PortoProgressBarViewModel.ProgressInfo(
            totalValue: totalValue,
            currentValue: currentValue
        )
        let viewModel = PortoProgressBarViewModel(
            progressInfo: progressInfo,
            barType: .solid,
            barColor: .white,
            hasAlphaBackground: true
        )
        return viewModel
    }
}

// MARK: - Gradient

extension UIView {
    fileprivate func applyGradient(
        colors: [UIColor],
        locations: [NSNumber]? = nil,
        startPoint: CGPoint,
        endPoint: CGPoint
    ) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        if let locations {
            gradientLayer.locations = locations
        }
        
        layer.sublayers?.forEach { if $0 is CAGradientLayer { $0.removeFromSuperlayer() } }
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
