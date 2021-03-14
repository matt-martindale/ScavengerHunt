//
//  UIViewController+Extension.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/13/21.
//

import UIKit

extension UIViewController {
    func hideKeyboardOnTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
