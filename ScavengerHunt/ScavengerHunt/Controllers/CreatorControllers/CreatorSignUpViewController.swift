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
    @IBOutlet weak var firstNameTextfield: FloatingLabel!
    @IBOutlet weak var lastNameTextfield: FloatingLabel!
    @IBOutlet weak var companyTextfield: FloatingLabel!
    @IBOutlet weak var emailTextfield: FloatingLabel!
    @IBOutlet weak var passwordTextfield: FloatingLabel!
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

    // MARK: - IBActions
    @IBAction func signUpBtnTapped(_ sender: UIButton) {
        Utilites.shared.playSound(sender.tag)
        // check if form error exists
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
                    guard let result = result else { return }
                    db.collection("users").document(result.user.uid).setData(["firstName":firstName,
                                                              "lastName":lastName,
                                                              "company":company,
                                                              "email":email,
                                                              "events":[String](),
                                                              "uid":result.user.uid]) { [weak self] error in
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
        
        firstNameTextfield.becomeFirstResponder()
        firstNameTextfield.addBottomBorder()
        lastNameTextfield.addBottomBorder()
        companyTextfield.addBottomBorder()
        emailTextfield.addBottomBorder()
        passwordTextfield.addBottomBorder()
        firstNameTextfield.delegate = self
        lastNameTextfield.delegate = self
        companyTextfield.delegate = self
        emailTextfield.delegate = self
        passwordTextfield.delegate = self
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
        let storyboard = UIStoryboard(name: "Creator", bundle: nil)
        let tabbarVC = storyboard.instantiateViewController(identifier: "UITabbarController") as! UITabBarController
        guard let vcs = tabbarVC.viewControllers,
              let nc = vcs.first as? UINavigationController else { return }
        
        // Set tabbar items
        let homeVCTabbarItem = UITabBarItem(title: "Events", image: UIImage(systemName: "house"), tag: 0)
        let playVCTabbarItem = UITabBarItem(title: "Play", image: UIImage(systemName: "iphone.homebutton.badge.play"), tag: 1)
        vcs[0].tabBarItem = homeVCTabbarItem
        vcs[1].tabBarItem = playVCTabbarItem
        
        nc.navigationBar.prefersLargeTitles = true
        UIApplication.shared.windows.first?.rootViewController = tabbarVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
}

extension CreatorSignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = textField.superview?.viewWithTag(textField.tag + 1) as? FloatingLabel {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}
