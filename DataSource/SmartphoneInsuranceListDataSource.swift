//
//  SmartphoneInsuranceListDataSource.swift
//  Smartphone
//
//  Created by Hugo Hernany da Silva Cabral on 10/03/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Components
import Core
import CoreLocation
import UIKit

open class SmartphoneInsuranceListDataSource: NSObject {
    // MARK: - Constants

    private enum Constants {
        static let maxCellsInSection = 6
        static let minimumNumberOfRows = 1
        static let numberOfRowsWhenCollapsed = 1
        static let singleCellZPosition: CGFloat = 1.0
    }

    // MARK: - Private Properties

    private let viewModel: SmartphoneInsuranceListViewModelProtocol

    private var tableView: UITableView?
    private var selectedSection: Int = .zero
    private var sectionModels = [ExpandableTableViewCellModelProtocol]()
    private var smartphoneAvailability: ProductAvailability?
    private var isSmartphoneProductAvailable: Bool {
        smartphoneAvailability?.isAvailable ?? true
    }
    
    private var isBannerHidden: Bool {
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        return authorizationStatus == .authorizedAlways || !FeatureToggle.isAvailable(.smartphoneLocationBanner) || !viewModel.hasSmartphoneProduct
    }

    // MARK: - Computed Properties

    private var numberOfSections: Int {
        let sections: Int
        
        let geoLocationRowSection = isBannerHidden ?
            Int.zero : Constants.minimumNumberOfRows

        if !isSmartphoneProductAvailable {
            sections = Constants.minimumNumberOfRows
        } else if sectionModels.isEmpty {
            sections = Constants.minimumNumberOfRows
        } else {
            sections = sectionModels.count + geoLocationRowSection
        }

        return sections
    }

    // MARK: - Initializer

    public required init?(viewModel: SmartphoneInsuranceListViewModelProtocol?) {
        sectionModels.removeAll()

        guard let viewModel = viewModel else { return nil }
        self.viewModel = viewModel
        
        smartphoneAvailability = RemoteConfig.getDecodableValue(from: .smartphoneAvailability)
        
        super.init()

        bindElements()

        if isSmartphoneProductAvailable {
            viewModel.fetchInsuranceStatus(forceUpdate: false)
        }
    }

    // MARK: - Configuration Methods

    /// Method to setup and update tableView
    /// - Parameters:
    ///   - tableView: tableView to be setup and updated.
    public func reloadTableView(_ tableView: UITableView?) {
        self.tableView = tableView
        guard let tableView = tableView else { return }

        tableView.dataSource = self
        tableView.delegate = self

        /// Register Nib
        let nib = UINib(nibName: ExpandableTableViewCell.className, bundle: Bundle(for: ExpandableTableViewCell.self))
        tableView.register(nib, forCellReuseIdentifier: ExpandableTableViewCell.className)
        tableView.registerCell(NoProductAvailableTableViewCell.self)
        tableView.registerCell(NoGeoLocationWarningCell.self)
        
        tableView.estimatedRowHeight = UITableView.automaticDimension
        UIView.transition(with: tableView, duration: 0.2, options: .transitionCrossDissolve) {
            tableView.reloadData()
        }
    }

    private func viewStateCheck(viewState: SmartphoneInsuranceListViewState) {
        switch viewState {
        case .success(let data):
            sectionModels = data
            reloadTableView(tableView)
            updateTableViewAndExpandFirstSection()
            return
        case .reloading:
            reloadTableView(tableView)
            tableView?.setContentOffset(.zero, animated: true)
        default:
            reloadTableView(tableView)
        }
    }

    private func bindElements() {
        viewModel.viewState.bind { [weak self] viewState in
            guard let self = self else { return }
            self.viewStateCheck(viewState: viewState)
        }

        viewModel.sectionModels.bind { [weak self] sectionModels in
            guard let self = self else { return }
            self.sectionModels = sectionModels
        }
    }

    private func buildNoProductAvailableCell(at indexPath: IndexPath, tableView: UITableView) -> UITableViewCell {
        let icon = NoProductAvailableViewType.icon(.smartphoneAlert)
        let title = LocalizableBundle.smartphoneProductUnavailableTitle.localize
        let description = smartphoneAvailability?.subtitle
        let actionType = smartphoneAvailability?.buttonActionType
        let analytics = NoProductAvailableHomeAnalytics(productName: "celular")

        let noProductAvailableViewModel = NoProductAvailableViewModel(iconType: icon,
                                                                      titleMessage: title,
                                                                      descriptionMessage: description,
                                                                      productActionType: actionType,
                                                                      buttonAction: viewModel.productUnavailableCompletion,
                                                                      analyticsBuilder: analytics)

        let cell = NoProductAvailableTableViewCell.build(in: tableView, with: indexPath, and: noProductAvailableViewModel, zPosition: Constants.singleCellZPosition)
        cell.selectionStyle = .none
        
        return cell
    }

    // MARK: - Expand/Collapse Methods
    
    private func updateTableViewAndExpandFirstSection() {
        let firstInsuranceSection: Int = .zero
        guard let firstItem = sectionModels[firstInsuranceSection] as? SmartphoneInsuranceListSectionModel, firstItem.type == .inspection else {
            return
        }
        expandCard(position: firstInsuranceSection)
        selectedSection = firstInsuranceSection
    }

    private func didSelectHeaderCell(at indexPath: IndexPath) {
        guard !sectionModels.isEmpty else { return }
        let index = !isBannerHidden ? (indexPath.section - 1) : indexPath.section

        let sectionModel = sectionModels[index]

        let isSelectedHeaderExpanded = sectionModel.isExpanded
        
        let oldHeaderViewModel = sectionModels[selectedSection]
        if index != selectedSection, oldHeaderViewModel.isExpanded {
            collapseCard(position: selectedSection)
            selectedSection = index
            expandCard(position: selectedSection)
            viewModel.trackExpandAndCollapse(isExpanded: true, position: selectedSection)
            let cell = tableView?.cellForRow(at: IndexPath(row: indexPath.row, section: selectedSection))
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                UIAccessibility.post(notification: .layoutChanged, argument: cell?.accessibilityElements?.first)
            }
        } else {
            
            selectedSection = index
            
            if isSelectedHeaderExpanded {
                collapseCard(position: selectedSection)
                viewModel.trackExpandAndCollapse(isExpanded: false, position: selectedSection)
            } else {
                expandCard(position: selectedSection)
                viewModel.trackExpandAndCollapse(isExpanded: true, position: selectedSection)
            }
        }
    }

    private func collapseCard(position: Int) {
        viewModel.updateSectionModelsForCollapse(position: position)
        let truePosition = !isBannerHidden ? (position + 1) : position
        
        tableView?.beginUpdates()
        tableView?.reloadSections([truePosition], with: .automatic)
        tableView?.endUpdates()
    }

    private func expandCard(position: Int) {
        viewModel.updateSectionModelsForExpand(position: position)
        let truePosition = !isBannerHidden ? (position + 1) : position

        tableView?.beginUpdates()
        tableView?.reloadSections([truePosition], with: .automatic)
        tableView?.endUpdates()
    }
    
    private func didSentToGeoLocationView() {
        viewModel.noGeoLocationAction()
    }

    // MARK: - Table View Helpers

    private func numberOfRowsInSection(_ section: Int) -> Int {
        return Constants.numberOfRowsWhenCollapsed
    }
}

// MARK: - Table View Delegate

extension SmartphoneInsuranceListDataSource: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = !isBannerHidden ? (indexPath.section - 1) : indexPath.section

        if let cell = tableView.cellForRow(at: indexPath) as? NoGeoLocationWarningCell {
            let action = {
                // Intentionally unimplemented...
            }
            (cell.action ?? action)()
            return
        }
        guard indexPath.row == .zero, index < sectionModels.count else { return }
        let firstItem = sectionModels[indexPath.row] as? SmartphoneInsuranceListSectionModel

        switch firstItem?.type {
        case .inspection:
            if sectionModels.count > Constants.minimumNumberOfRows {
                didSelectHeaderCell(at: indexPath)
            }
        case .insurance:
            didSelectHeaderCell(at: indexPath)
        default:
            return
        }
    }
}

// MARK: - Table View Data Source

extension SmartphoneInsuranceListDataSource: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let shouldAddGeoLoaction = (indexPath.section == Int.zero && indexPath.row == Int.zero) && !isBannerHidden
        
        if shouldAddGeoLoaction {
            
            return NoGeoLocationWarningCell.rowHeight
        }
        
        return UITableView.automaticDimension
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        numberOfSections
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfRowsInSection(section)
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if !isSmartphoneProductAvailable {
            return buildNoProductAvailableCell(at: indexPath,
                                               tableView: tableView)
        }
        
        let index = !isBannerHidden ? (indexPath.section - 1) : indexPath.section
        
        guard index < sectionModels.count else { return UITableViewCell() }

        let highZPosition = CGFloat(Constants.maxCellsInSection * (numberOfSections - indexPath.section))
        let zPositionCell = highZPosition - CGFloat(indexPath.row)

        let shouldAddGeoLoaction = (indexPath.section == Int.zero && indexPath.row == Int.zero) && !isBannerHidden
        
        if shouldAddGeoLoaction {
            var model = NoGeoLocationWarningViewModel.createDefaultModel()
            model.insert(action: didSentToGeoLocationView)
            let cell = NoGeoLocationWarningCell.build(in: tableView,
                                                      and: model,
                                                      zPosition: zPositionCell)
            
            return cell
        } else {
            
            return ExpandableTableViewCell.build(in: tableView, and: sectionModels[index], zPosition: zPositionCell)
        }
    }
}

extension UITableView {
    /// Quicker way to register a nib object containing a table view cell.
    /// - Parameter cellType: Class type of the cell to be registered.
    func registerNib<T: UITableViewCell>(_ cellType: T.Type) {
        let nib = UINib(nibName: cellType.className, bundle: .getBundle)
        register(nib, forCellReuseIdentifier: cellType.className)
    }
}
