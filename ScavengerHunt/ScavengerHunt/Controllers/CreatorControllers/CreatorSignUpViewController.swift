//
//  CreatorSignUpViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/11/21.
//

import UIKit

class CreatorSignUpViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var lastNameTextfield: UITextField!
    @IBOutlet weak var companyTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        errorLabel.alpha = 0.0
    }
    
    // MARK: - Methods
    private func setupViews() {
        errorLabel.alpha = 0.0
        signUpBtn.layer.cornerRadius = 20
        
        firstNameTextfield.addBottomBorder()
        lastNameTextfield.addBottomBorder()
        companyTextfield.addBottomBorder()
        emailTextfield.addBottomBorder()
        passwordTextfield.addBottomBorder()
    }

    @IBAction func signUpBtnTapped(_ sender: Any) {
    }
    
    private func validateFields() -> String? {
        if firstNameTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
               emailTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        return nil
    }
    
}
