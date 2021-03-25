//
//  PlayerFormViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/24/21.
//

import UIKit

class PlayerFormViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var beginBtn: UIButton!
    @IBOutlet weak var beginBtnLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    @IBAction func beginBtnTapped(_ sender: UIButton) {
    }
    
    @IBAction func beginBtnHeld(_ sender: UIButton) {
        Utilites.shared.playSound(sender.tag)
        
        sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        beginBtnLabel.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 1.0, options: UIView.AnimationOptions.allowUserInteraction, animations: { [weak self] in
            sender.transform = CGAffineTransform.identity
            self?.beginBtnLabel.transform = CGAffineTransform.identity
        }, completion: { Void in()})
    }
    
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        Utilites.shared.playSound(sender.tag)
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Methods
    func setupViews() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.compactAppearance = .none
        firstNameTextField.addBottomBorder()
        lastNameTextField.addBottomBorder()
        emailTextField.addBottomBorder()
        
        beginBtn.adjustsImageWhenHighlighted = false
        
        cancelBtn.layer.cornerRadius = 20
        cancelBtn.layer.borderWidth = 2.0
        cancelBtn.layer.borderColor = UIColor.orange.cgColor
        
    }

}
