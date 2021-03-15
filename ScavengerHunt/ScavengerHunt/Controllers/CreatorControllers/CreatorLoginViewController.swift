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
        checkIfCurrentUserExists()
        setupViews()
        hideKeyboardOnTap()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
    @IBAction func loginBtnTapped(_ sender: UIButton) {
        Utilites.shared.playSound(sender.tag)
        let error = validateFields()
        
        // Check if there's a textField validation error
        if let error = error {
            Utilites.shared.showError(error, errorLabel: errorLabel)
        } else {
            
            // Hide errorLabel create cleaned email & password
            errorLabel.alpha = 0.0
            guard let email = emailTextField?.text?.trimmingCharacters(in: .whitespacesAndNewlines),
                  let password = passwordTextField?.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
                guard let strongSelf = self else { return }
                
                // Check if there's an error
                if error != nil {
                    print(error!.localizedDescription)
                    Utilites.shared.showError(error!.localizedDescription, errorLabel: strongSelf.errorLabel)
                } else {
                    // User logged in Successfully
                    UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: Constants.userUIDKey)
                    UserDefaults.standard.synchronize()
                    strongSelf.transitionToHome()
                }
            }
        }
    }
    
    @IBAction func signInBtnTapped(_ sender: UIButton) {
        Utilites.shared.playSound(sender.tag)
    }
    
    // MARK: - Methods
    private func validateFields() -> String? {
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        }
        return nil
    }
    
    private func transitionToHome() {
        guard let creatorHomeVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.creatorHomeVC) as? CreatorHomeViewController else { return }
        navigationController?.pushViewController(creatorHomeVC, animated: true)
    }
    
    private func checkIfCurrentUserExists() {
        if UserDefaults.standard.object(forKey: Constants.userUIDKey) != nil {
            guard let creatorHomeVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.creatorHomeVC) as? CreatorHomeViewController else { return }
            navigationController?.pushViewController(creatorHomeVC, animated: true)
        }
    }
    
}
