//
//  UITextField+Extension.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/13/21.
//

import UIKit

extension UITextField {
    func addBottomBorder() {
        let bottomLayer = CALayer()
        bottomLayer.frame = CGRect(x: 0.0, y: self.frame.height - 1, width: self.frame.width - 20, height: 2.0)
        bottomLayer.backgroundColor = UIColor.orange.cgColor
        self.borderStyle = .none
        self.tintColor = .orange
        self.layer.addSublayer(bottomLayer)
    }
    
    func validateField() -> String? {
        if self.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        return nil
    }
    
}
