//
//  CreatorLoginViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/11/21.
//

import UIKit

class CreatorLoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var signUpBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        loginBtn.layer.cornerRadius = 20
        
        signUpBtn.layer.cornerRadius = 20
        signUpBtn.layer.borderWidth = 2.0
        signUpBtn.layer.borderColor = UIColor.orange.cgColor
        
    }

}
