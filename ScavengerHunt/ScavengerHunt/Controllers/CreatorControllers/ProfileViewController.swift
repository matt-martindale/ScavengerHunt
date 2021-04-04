//
//  ProfileViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 4/4/21.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            if Auth.auth().currentUser == nil {
                UserDefaults.standard.removeObject(forKey: Constants.userUIDKey)
                UserDefaults.standard.synchronize()
            }
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("Error signing out")
        }
    }

}
