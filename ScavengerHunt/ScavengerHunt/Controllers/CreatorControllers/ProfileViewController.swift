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
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logOutBtn: UIButton!
    
    // MARK: - Properties
    var db = Firestore.firestore()
    var profileData: [String] = ["0.9"]
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setupViews()
    }
    
    // MARK: - IBActions
    @IBAction func logOutBtnTapped(_ sender: UIButton) {
        signOut()
    }
    
    // MARK: - Methods
    func setupViews() {
        logOutBtn.layer.cornerRadius = 20
        logOutBtn.layer.borderWidth = 2.0
        logOutBtn.layer.borderColor = UIColor.orange.cgColor
        avatarImage.image = Utilites.shared.getMonsterImage()
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
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
                    let firstName = data["firstName"] as? String ?? ""
                    let lastName = data["lastName"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let company = data["company"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        self.nameLabel.text = firstName + " " + lastName
                        self.emailLabel.text = email
                        self.companyLabel.text = company
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

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.profileTableViewCell) as? UITableViewCell else { return UITableViewCell() }
        let data = profileData[indexPath.row]
        
        return cell
    }
    
    
}
