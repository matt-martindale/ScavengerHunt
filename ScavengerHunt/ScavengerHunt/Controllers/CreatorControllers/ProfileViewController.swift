//
//  ProfileViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 4/4/21.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var nameLabel: UILabel!
    
    // MARK: - Properties
    var db = Firestore.firestore()
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - IBActions
    
    // MARK: - Methods
    func setupViews() {
        fetchUserInfo()
    }
    
    func fetchUserInfo() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let userRef = db.collection("users").document(userID)
        
        DispatchQueue.global(qos: .default).async {
            userRef.getDocument { [weak self] document, error in
                guard let self = self else { return }
                guard error == nil else {
                    print("Error retrieving User Info: \(error!)")
                    return
                }
                
                if let document = document, document.exists {
                    guard let data = document.data() else { return }
                    // User Data
                    guard let firstName = data["firstName"] as? String,
                          let lastName = data["lastName"] as? String else { return }
                    
                    DispatchQueue.main.async {
                        self.nameLabel.text = String(firstName + " " + lastName)
                    }
                    
                }
            }
        }
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
