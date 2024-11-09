//
//  InsuranceInstallmentsView.swift
//  Smartphone
//
//  Created by Jeff on 08/11/24.
//

import Foundation
import DesignSystem

final class InsuranceInstallmentsView: UIView {
    
    // MARK: - CallBack

    var onBackTapped: (() -> Void)?

    // MARK: - Views
    
    private lazy var navigationBar: PortoNavigationView = {
        let navigationViewModel = PortoNavigationViewModel(
            accessibleTexts: .init(accessibleTitle: "Contratação Seguro Celular"),
            style: .holding(variation: .color100)
        )
        let navigation = PortoNavigationView.instantiate(viewModel: navigationViewModel) { [weak self] _ in
            guard let self = self else { return }
            self.onBackTapped?()
        }
        return navigation
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        return scrollView
    }()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .fill
        return stackView
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
}

// MARK: - Private Methods

extension InsuranceInstallmentsView {
    
    // MARK: - Build View Hierarchy

    private func buildViewHierarchy() {
        addSubview(navigationBar)
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(stackView)
        addSubview(footerView)
    }

    // MARK: - Build View Constraints

    private func buildViewConstraints() {
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(footerView.snp.top)
        }

        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(32)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }

        footerView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(178)
        }
    }
}
