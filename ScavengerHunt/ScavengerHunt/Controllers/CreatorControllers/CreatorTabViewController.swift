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
        setupBarBtns()
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    private func setupBarBtns() {
        let profileBarBtn = UIBarButtonItem(image: UIImage(systemName: "person.circle"), style: .plain, target: self, action: #selector(goToProfileView))
        profileBarBtn.tintColor = .white
        
        let helpBarBtn = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(goToHelpView))
        helpBarBtn.tintColor = .orange
        
        navigationItem.rightBarButtonItems = [profileBarBtn, helpBarBtn]
    }
    
    @objc func goToProfileView() {
        guard let profileVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.profileVC) as? ProfileViewController else { return }
        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    @objc func goToHelpView() {
        guard let creatorHelpVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.creatorHelpVC) as? CreatorHelpViewController else { return }
        navigationController?.present(creatorHelpVC, animated: true, completion: nil)
    }

}
