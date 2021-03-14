//
//  CreateEventViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/14/21.
//

import UIKit

class CreateEventViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.hideKeyboardOnTap()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        errorLabel.alpha = 0.0
    }
    
    // MARK: - Methods
    private func setupViews() {
        titleTextField.layer.cornerRadius = 20
        titleTextField.addBottomBorder()
        
        descriptionTextView.layer.borderWidth = 2.0
        descriptionTextView.layer.borderColor = UIColor.orange.cgColor
        descriptionTextView.backgroundColor = .clear
        
        errorLabel.alpha = 0.0
    }
    
}
