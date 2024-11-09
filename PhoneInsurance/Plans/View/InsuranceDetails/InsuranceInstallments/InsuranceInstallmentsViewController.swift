import DesignSystem
import UIKit

protocol InsuranceInstallmentsDisplaying: AnyObject {}

private extension InsuranceInstallmentsViewController.Layout {
    // example
    enum Size {
        static let imageHeight: CGFloat = 90.0
    }
}

final class InsuranceInstallmentsViewController: PhoneInsuranceBaseViewController<InsuranceInstallmentsInteracting, InsuranceInstallmentsView> {
    enum Layout { }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .portoSeguros100

        
        rootView.onBackTapped = {[weak self] in
            guard let self = self else { return }
            self.interactor.back()
        }
    }
}

extension InsuranceInstallmentsViewController: InsuranceInstallmentsDisplaying {}
