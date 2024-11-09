import DesignSystem
import UIKit
import SnapKit
import Combine

protocol PhoneInsurancePlansDisplaying: AnyObject {}

protocol PhoneInsurancePlansViewProviding {
    func provideSubviews() -> [PhoneInsuranceSubviewType: UIView]
    func configureSubviews(with subviews: [PhoneInsuranceSubviewType: UIView])
}

final class PhoneInsurancePlansViewController: PhoneInsuranceBaseViewController<PhoneInsurancePlansInteracting, PhoneInsurancePlansView> {
    
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Dependencies

    private let viewProvider: PhoneInsurancePlansViewProviding

    // MARK: - Initialization

    init(interactor: PhoneInsurancePlansInteracting, viewProvider: PhoneInsurancePlansViewProviding) {
        self.viewProvider = viewProvider
        super.init(interactor: interactor)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .portoSeguros100

        let subviews = viewProvider.provideSubviews()
        rootView.configureSubviews(subviews)
        viewProvider.configureSubviews(with: subviews)
        setupBindings()
        
        rootView.onBackTapped = { [weak self] in
            guard let self = self else { return }
            handleBackButton()
        }
    }
}

// MARK: - Private Methods

extension PhoneInsurancePlansViewController {
    
    private func setupBindings() {
        EventBus.shared.otherDeviceButtonTapAction
            .sink { [weak self] in
                guard let self = self else { return }
                self.handleOtherDeviceButtonTapped()
            }
        .store(in: &cancellables)
        
        EventBus.shared.editInstallments
            .sink { [weak self] in
                guard let self = self else { return }
                self.handleEditInstallmentsButtonTapped()
            }
        .store(in: &cancellables)

    }
    
    @objc private func handleOtherDeviceButtonTapped() {
        interactor.openHub()
    }
    
    @objc private func handleEditInstallmentsButtonTapped() {
        interactor.editInstallments()
    }
    
    private func handleBackButton() {
        interactor.back()
    }
}

extension PhoneInsurancePlansViewController: PhoneInsurancePlansDisplaying {}
