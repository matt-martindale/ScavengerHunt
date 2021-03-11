//
//  LandingPageViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/10/21.
//

import UIKit

class LandingPageViewController: UIViewController {
    
    @IBOutlet weak var playLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        playLabel.text = "PLAY\nSCAVENGER HUNT"
    }

}
