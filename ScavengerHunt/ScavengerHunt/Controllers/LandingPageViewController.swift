//
//  LandingPageViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/10/21.
//

import UIKit

class LandingPageViewController: UIViewController {
    
    @IBOutlet weak var playLabel: UILabel!
    @IBOutlet weak var helpButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        playLabel.text = "PLAY\nSCAVENGER HUNT"
        
        helpButton.contentVerticalAlignment = .fill
        helpButton.contentHorizontalAlignment = .fill
        helpButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }

}
