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
    
    // MARK: - IBActions
    @IBAction func confirmBtnTapped(_ sender: UIButton) {
        Utilites.shared.playSound(sender.tag)
        validateFields()
    }
    
    // MARK: - Methods
    private func setupViews() {
        titleTextField.layer.cornerRadius = 20
        titleTextField.addBottomBorder()
        descriptionTextView.layer.borderWidth = 2.0
        descriptionTextView.layer.borderColor = UIColor.orange.cgColor
        descriptionTextView.backgroundColor = .clear
        descriptionTextView.layer.cornerRadius = 10
        descriptionTextView.tintColor = .orange
        confirmBtn.layer.cornerRadius = 20
        errorLabel.alpha = 0.0
    }
    
    private func validateFields() {
        if titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            Utilites.shared.showError("Please enter an Event title", errorLabel: errorLabel)
        }
    }
    
}
