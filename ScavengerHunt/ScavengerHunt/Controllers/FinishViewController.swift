//
//  FinishViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/28/21.
//

import UIKit

class FinishViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var congratsImageView: UIImageView!
    @IBOutlet weak var homeBtn: UIButton!
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationController?.isNavigationBarHidden = true
    }

    // MARK: - IBActions
    @IBAction func homeBtnTapped(_ sender: UIButton) {
    }
    
    // MARK: - Methods
    func setupViews() {
        homeBtn.layer.cornerRadius = 20
        homeBtn.layer.borderWidth = 2.0
        homeBtn.layer.borderColor = UIColor.orange.cgColor
    }
}
