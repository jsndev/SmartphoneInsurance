//
//  NoGeoLocationWarningCell.swift
//  Smartphone
//
//  Created by Stefan Vargas on 29/09/21.
//  Copyright © 2021 Porto Seguro. All rights reserved.
//

import Components
import Core
import DesignSystem
import SnapKit
import UIKit

class NoGeoLocationWarningCell: UITableViewCell {

    // MARK: - Constants
    
    private enum Constants {
        static let margin: CGFloat = 24.0
        static let bottomMargin: CGFloat = -8.0
        static let cornerRadius: CGFloat = 4.0
        static let topMargin: CGFloat = 6.0
        static let iconLeading: CGFloat = 12.0
        static let iconSize: CGFloat = 18.0
        static let arrowSize: CGFloat = 11.0
        static let titleLeading: CGFloat = 10.0
        static let arrowDistance: CGFloat = 16.0
        static let noGeoLocationCellId = "smartphone_noGeolocation_id"
    }

    // MARK: - accessible Static Properties
    
    static let rowHeight: CGFloat = 64.0

    // MARK: - Other Properties
    
    var action: GenericAction?
    
    // MARK: - Layout Components
    
    lazy var mainViewButton: UIButton = {
        
        let buttonView = UIButton()
        buttonView.backgroundColor = .brandColorPrimary
        buttonView.translatesAutoresizingMaskIntoConstraints = false
        buttonView.layer.cornerRadius = Constants.cornerRadius
        
        return buttonView
    }()
    
    private lazy var arrowLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .right
        label.font = UIFont(name: .icomoon, size: .extraMinimum)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var iconLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: .icomoon, size: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = UIFont(name: .regular, size: .small)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        return label
    }()
    
    // MARK: - Initializer
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: NoGeoLocationWarningCell.className)
        loadView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        loadView()
    }
    
    // MARK: - Instantiate

    public static func build(in tableView: UITableView, and model: NoGeoLocationWarningViewModelProtocol?, zPosition: CGFloat) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NoGeoLocationWarningCell.className) as? NoGeoLocationWarningCell,
              let mainModel = model as? NoGeoLocationWarningViewModel
        else { return UITableViewCell() }
  
        cell.setup(with: mainModel, in: zPosition)
        
        return cell
    }
    
    private func setup(with cellModel: NoGeoLocationWarningViewModel, in position: CGFloat = CGFloat.zero) {
        selectionStyle = .none
        layer.zPosition = position
        backgroundColor = .clear
        setupMainView(with: cellModel)
    }
    
    // MARK: - Private Methods

    private func setupMainView(with cellModel: NoGeoLocationWarningViewModel) {
        mainViewButton.backgroundColor = cellModel.backGroundColor
        mainViewButton.layer.zPosition = layer.zPosition - 1
        mainViewButton.accessibilityLabel = cellModel.title.value
        mainViewButton.accessibilityIdentifier = Constants.noGeoLocationCellId
        titleLabel.text = cellModel.title.value
        iconLabel.text = cellModel.icon.codeToIcon
        arrowLabel.text = cellModel.arrow.value.codeToIcon
        action = cellModel.action
        mainViewButton.addTarget(self, action: #selector(didTappedView), for: .touchUpInside)
    }
    
    // MARK: - Override Methods
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    // MARK: - Action Methods
    @objc
    func didTappedView() {
        if let cellAction = action {
            cellAction()
        } else {
            let emptyAction = {
                // Intentionally unimplemented...
            }
            emptyAction()
        }
    }    
}

// MARK: - Extension

extension NoGeoLocationWarningCell: ViewCoding {
    func addSubviews() {
        addSubview(mainViewButton)
        mainViewButton.addSubview(iconLabel)
        mainViewButton.addSubview(titleLabel)
        mainViewButton.addSubview(arrowLabel)
    }
    
    func addConstraints() {
        mainViewButton.snp.makeConstraints { maker in
            maker.leading.leading.equalTo(Constants.margin)
            maker.trailing.equalTo(-Constants.margin)
            maker.bottom.equalTo(Constants.bottomMargin)
            maker.top.equalTo(Constants.topMargin)
        }
        
        iconLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(Constants.iconLeading)
            maker.centerY.equalToSuperview()
            maker.width.height.equalTo(Constants.iconSize)
        }
        
        titleLabel.snp.makeConstraints { maker in
            maker.leading.equalTo(iconLabel.snp.trailing).offset(Constants.titleLeading)
            maker.centerY.equalToSuperview()
            maker.height.equalTo(Constants.iconSize)
        }
        
        arrowLabel.snp.makeConstraints { maker in
            maker.trailing.equalTo(-Constants.arrowDistance)
            maker.centerY.equalToSuperview()
            maker.width.height.equalTo(Constants.arrowSize)
        }
    }
}
