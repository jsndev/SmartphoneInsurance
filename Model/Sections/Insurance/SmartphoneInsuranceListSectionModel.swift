//
//  SmartphoneInsuranceListSectionModel.swift
//  Smartphone
//
//  Created by Hugo Hernany da Silva Cabral on 10/03/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Components
import Core
import Insurance

// MARK: - Smartphone Data Content Type

public enum SmartphoneContentType {
    case insurance
    case inspection
}

// MARK: - Smartphone Content View Model Types

public enum SmartphoneContentViewModelType {
    case header
    case installments
    case message
}

// MARK: - Smartphone Content View Model Protocol

public protocol SmartphoneContentsViewModelProtocol: BaseViewModel {
    /// ViewModel of a specific view
    var viewModel: BaseViewModel? { get set }
    /// Type of content view model
    var type: SmartphoneContentViewModelType? { get set }

    // MARK: - Initializer

    /// Initializer
    /// - Parameters:
    ///   - viewModel: ViewModel of a specific view
    ///   - type: Type of content
    init(viewModel: BaseViewModel, type: SmartphoneContentViewModelType)
}

// MARK: - Smartphone Content View Model

class SmartphoneContentViewModel: SmartphoneContentsViewModelProtocol {
    var viewModel: BaseViewModel?
    var type: SmartphoneContentViewModelType?

    required init(viewModel: BaseViewModel, type: SmartphoneContentViewModelType) {
        self.viewModel = viewModel
        self.type = type
    }
}

// MARK: - Smartphone Insurance Sections

class ContentData {
    var insuranceData: SmartphoneInsuranceData?
    var inspectionData: InspectionDataModel?
    var urls: InspectionURLS?

    // MARK: - Initializer

    /// Initializer
    /// - Parameters:
    ///   - insuranceData: Insurance Data from login
    ///   - inspectionData: Inspection Data from service
    ///   - urls: URLs
    init(insuranceData: SmartphoneInsuranceData?, inspectionData: InspectionDataModel?, urls: InspectionURLS?) {
        self.insuranceData = insuranceData
        self.inspectionData = inspectionData
        self.urls = urls
    }
}

class SmartphoneInsuranceListSectionModel: ExpandableTableViewCellModelProtocol {
    var headerView: UIView
    var contentViews: [UIView]
    var isExpanded: Bool
    var type: SmartphoneContentType
    var contentData: ContentData?
    var headerViewModel: SmartphoneInsuranceHeaderViewModelProtocol?
    var viewModels: [SmartphoneContentsViewModelProtocol]?

    // MARK: - Initializer

    /// Initializer
    /// - Parameters:
    ///   - headerView: Header View
    ///   - contentViews: Array of Views for expandable content
    ///   - isExpanded: Cell status
    ///   - type: Content type of informations
    ///   - contentData: Content Data Informations
    ///   - headerViewModel: Header ViewModel
    ///   - viewModels: Content ViewModels
    init(headerView: UIView, contentViews: [UIView], isExpanded: Bool, type: SmartphoneContentType, contentData: ContentData?, headerViewModel: SmartphoneInsuranceHeaderViewModelProtocol?, viewModels: [SmartphoneContentsViewModelProtocol]? = []) {
        self.headerView = headerView
        self.contentViews = contentViews
        self.isExpanded = isExpanded
        self.type = type
        self.contentData = contentData
        self.headerViewModel = headerViewModel
        self.viewModels = viewModels
    }
}
