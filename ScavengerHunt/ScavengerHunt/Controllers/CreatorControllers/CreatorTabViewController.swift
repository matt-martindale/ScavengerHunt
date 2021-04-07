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
        navigationItem.setHidesBackButton(true, animated: true)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }

}
