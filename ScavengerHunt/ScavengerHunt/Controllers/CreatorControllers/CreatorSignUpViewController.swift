//
//  CreatorSignUpViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/11/21.
//

import UIKit
import FirebaseAuth
import Firebase

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
        self.hideKeyboardOnTap()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        errorLabel.alpha = 0.0
    }

    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        Utilites.shared.playSound(sender.tag)
        let error = validateFields()
        
        if error != nil {
            Utilites.shared.showError(error!, errorLabel: errorLabel)
        } else {
            errorLabel.alpha = 0.0
            
            let firstName = firstNameTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let company = companyTextfield.text ?? "N/A"
            let email = emailTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
                guard let strongSelf = self else { return }
                
                // Check for error creating User
                if let error = error {
                    Utilites.shared.showError(error.localizedDescription, errorLabel: strongSelf.errorLabel)
                } else {
                // User created successfully
                    let db = Firestore.firestore()
                    db.collection("users").addDocument(data: ["firstName":firstName,
                                                              "lastName":lastName,
                                                              "company":company,
                                                              "email":email,
                                                              "events":[String](),
                                                              "uid":result!.user.uid]) { [weak self] error in
                        guard let strongSelf = self else { return }
                        
                        if error != nil {
                            Utilites.shared.showError(error!.localizedDescription, errorLabel: strongSelf.errorLabel)
                        }
                    }
                    // Transition to home screen
                    UserDefaults.standard.set(Auth.auth().currentUser?.uid, forKey: Constants.userUIDKey)
                    UserDefaults.standard.synchronize()
                    strongSelf.transitionToHome()
                }
            }
        }
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
    
    private func validateFields() -> String? {
        if firstNameTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
               emailTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        }
        
        // Check if password is secure
        let cleanedPassword = passwordTextfield.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilites.shared.isPasswordValid(cleanedPassword) == false {
            return "Please make sure your password is at least 8 characters, contains a special character and a number."
        }
        return nil
    }
    
    private func transitionToHome() {
        guard let creatorHomeVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.creatorHomeVC) as? CreatorHomeViewController else { return }
        navigationController?.pushViewController(creatorHomeVC, animated: true)
    }
    
}
