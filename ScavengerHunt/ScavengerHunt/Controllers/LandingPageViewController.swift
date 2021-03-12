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
    @IBOutlet weak var playButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func setupView() {
        self.navigationController?.isNavigationBarHidden = true
        playLabel.text = "PLAY\nSCAVENGER HUNT"
        
        helpButton.contentVerticalAlignment = .fill
        helpButton.contentHorizontalAlignment = .fill
        helpButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        playButton.adjustsImageWhenHighlighted = false
    }

    @IBAction func playButtonTapped(_ sender: UIButton) {
        sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        playLabel.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 1.0, options: UIView.AnimationOptions.allowUserInteraction, animations: { [weak self] in
            sender.transform = CGAffineTransform.identity
            self?.playLabel.transform = CGAffineTransform.identity
        }, completion: { Void in()})
    }
}
