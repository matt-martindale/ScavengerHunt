//
//  CreatorHomeViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/13/21.
//

import UIKit
import Firebase
import FirebaseAuth

class CreatorHomeViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var label: UILabel!
    
    // MARK: - Properties
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserInfo()
        setupViews()
    }
    
    private func setupViews() {
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign Out", style: .plain, target: self, action: #selector(signOutBtnTapped))
    }
    
    func fetchUserInfo() {
        let currentUser = Auth.auth().currentUser
        label.text = currentUser?.email
    }
    
    @objc func signOutBtnTapped() {
        do {
            try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("Error signing out")
        }
    }
    
}
