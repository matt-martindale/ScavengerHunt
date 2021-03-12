//
//  Helpers.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/11/21.
//

import UIKit

extension UITextField {
    func addBottomBorder() {
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.width - 20, height: 2.0)
        bottomLayer.backgroundColor = UIColor.orange.cgColor
        self.borderStyle = .none
        self.layer.addSublayer(bottomLayer)
    }
    
    func validateFields(textFields: [UITextField]) -> String? {
        for textField in textFields {
            if textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                return "Please fill in all fields."
            }
        }
    }
    
}
