//
//  UIView+ParentViewController.swift
//  Smartphone
//
//  Created by Jeff on 07/11/24.
//

import UIKit
extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self.next
        while parentResponder != nil {
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
            parentResponder = parentResponder?.next
        }
        return nil
    }
}
