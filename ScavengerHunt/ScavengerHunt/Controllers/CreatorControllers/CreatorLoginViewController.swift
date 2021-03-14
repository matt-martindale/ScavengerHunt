//
//  CreatorLoginViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/11/21.
//

import UIKit
import FirebaseAuth

class CreatorLoginViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        errorLabel.alpha = 0.0
    }
    
    private func setupViews() {
        errorLabel.alpha = 0.0
        
        loginBtn.layer.cornerRadius = 20
        
        signUpBtn.layer.cornerRadius = 20
        signUpBtn.layer.borderWidth = 2.0
        signUpBtn.layer.borderColor = UIColor.orange.cgColor
        
        emailTextField.addBottomBorder()
        passwordTextField.addBottomBorder()
    }
    
    // MARK: - IBActions
    @IBAction func loginBtnTapped(_ sender: Any) {
//        Auth.auth().signIn(withEmail: email, password: password) { (result, possibleError) in
//            <#code#>
//        }
    }
    
    private func validateFields() -> String? {
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        return nil
    }
    
}
