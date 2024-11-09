//
//  PhoneInsuranceBaseViewController.swift
//  Smartphone
//
//  Created by Jefferson Fernandes on 30/10/24.
//  E-mail jeffersonf@ciandt.com
//

class PhoneInsuranceBaseViewController<Interactor, V: UIView>: UIViewController, ViewCodable {
    // MARK: - Properties

    let interactor: Interactor

    var rootView = V()

    // MARK: - Initialization

    init(interactor: Interactor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        buildViewLayout()
    }

    // MARK: - ViewCodable

    func buildViewHierarchy() {
        view.addSubview(rootView)
    }

    func buildViewConstraints() {
        view.stretch(view: rootView)
    }

    func additionalConfig() { }
}

// MARK: - ViewController where Interactor == Void

extension PhoneInsuranceBaseViewController where Interactor == Void {
    convenience init(_ interactor: Interactor = ()) {
        self.init(interactor: interactor)
    }
}
