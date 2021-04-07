//
//  CreatorTabViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 4/5/21.
//

import UIKit

class CreatorTabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBarBtn()
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupBarBtn() {
        let profileBarBtn = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(goToProfileView))
        profileBarBtn.tintColor = .white
        navigationItem.rightBarButtonItem = profileBarBtn
    }
    
    @objc func goToProfileView() {
        guard let profileVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.profileVC) as? ProfileViewController else { return }
        navigationController?.pushViewController(profileVC, animated: true)
    }

}
