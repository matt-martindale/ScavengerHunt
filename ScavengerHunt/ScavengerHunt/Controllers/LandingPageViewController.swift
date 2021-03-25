//
//  LandingPageViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/10/21.
//

import UIKit
import AVFoundation

class LandingPageViewController: UIViewController {
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var playLabel: UILabel!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var creatorButton: UIButton!
    
    // MARK: - Lifecycles
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

    // MARK: - IBActions
    @IBAction func playButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func playBtnHeld(_ sender: UIButton) {
        Utilites.shared.playSound(sender.tag)
        
        sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        playLabel.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 1.0, options: UIView.AnimationOptions.allowUserInteraction, animations: { [weak self] in
            sender.transform = CGAffineTransform.identity
            self?.playLabel.transform = CGAffineTransform.identity
        }, completion: { Void in()})
    }
    
    @IBAction func helpBtnTapped(_ sender: UIButton) {
        Utilites.shared.playSound(sender.tag)
    }
    
    @IBAction func createBtnTapped(_ sender: UIButton) {
        Utilites.shared.playSound(sender.tag)
    }
    
    // MARK: - Methods
    func setupView() {
        self.navigationController?.isNavigationBarHidden = true
        
        helpButton.contentVerticalAlignment = .fill
        helpButton.contentHorizontalAlignment = .fill
        helpButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        playButton.adjustsImageWhenHighlighted = false
        playLabel.text = "PLAY\nSCAVENGER HUNT"
        
        creatorButton.layer.cornerRadius = 20
        creatorButton.layer.borderWidth = 2.0
        creatorButton.layer.borderColor = UIColor.orange.cgColor
    }
    
}
