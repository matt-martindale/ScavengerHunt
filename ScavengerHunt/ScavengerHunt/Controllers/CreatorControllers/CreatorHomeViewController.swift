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

    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUserInfo()
    }
    
    func fetchUserInfo() {
        let currentUser = Auth.auth().currentUser
        label.text = currentUser?.email
    }

}
