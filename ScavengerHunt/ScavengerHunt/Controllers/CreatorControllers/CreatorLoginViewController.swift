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
    @IBOutlet weak var emailTextField: FloatingLabel!
    @IBOutlet weak var passwordTextField: FloatingLabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        emailTextField.becomeFirstResponder()
        emailTextField.addBottomBorder()
        passwordTextField.addBottomBorder()
        emailTextField.delegate = self
        passwordTextField.delegate = self
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
        let storyboard = UIStoryboard(name: "Creator", bundle: nil)
        let tabbarVC = storyboard.instantiateViewController(identifier: "UITabbarController") as! UITabBarController
        guard let vcs = tabbarVC.viewControllers else { return }
        
        // Set tabbar items
        let homeVCTabbarItem = UITabBarItem(title: "Events", image: UIImage(systemName: "house"), tag: 0)
        let playVCTabbarItem = UITabBarItem(title: "Play", image: UIImage(systemName: "iphone.homebutton.badge.play"), tag: 1)
        vcs[0].tabBarItem = homeVCTabbarItem
        vcs[1].tabBarItem = playVCTabbarItem
        
        navigationController?.pushViewController(tabbarVC, animated: true)
//        nc.navigationBar.prefersLargeTitles = true
//        UIApplication.shared.windows.first?.rootViewController = tabbarVC
//        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    private func checkIfCurrentUserExists() {
        if UserDefaults.standard.object(forKey: Constants.userUIDKey) != nil {
            let storyboard = UIStoryboard(name: "Creator", bundle: nil)
            guard let creatorHomeVC = storyboard.instantiateViewController(identifier: Constants.Storyboard.creatorHomeVC) as? CreatorHomeViewController else { return }
            let navController = UINavigationController(rootViewController: creatorHomeVC)
            navController.navigationBar.prefersLargeTitles = true
            UIApplication.shared.windows.first?.rootViewController = navController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }
    }
    
}

extension CreatorLoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = textField.superview?.viewWithTag(textField.tag + 1) as? FloatingLabel {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}
