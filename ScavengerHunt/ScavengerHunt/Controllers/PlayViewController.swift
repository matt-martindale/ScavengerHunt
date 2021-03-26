//
//  PlayViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/25/21.
//

import UIKit

class PlayViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var clueBoxImageView: UIImageView!
    @IBOutlet weak var clueLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var backbtn: UIButton!
    @IBOutlet weak var foundClueBtn: UIButton!
    
    // MARK: - Properties
    var event: Event?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        clueLabel.text = event?.markers.head?.clue
    }
    
    // MARK: - IBActions
    @IBAction func backBtnTapped(_ sender: UIButton) {
        Utilites.shared.playSound(sender.tag)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func foundClueBtnTapped(_ sender: UIButton) {
        Utilites.shared.playSound(sender.tag)
    }
    
    // MARK: - Methods
    func setupViews() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        backbtn.layer.cornerRadius = 20
        backbtn.layer.borderWidth = 2.0
        backbtn.layer.borderColor = UIColor.orange.cgColor
        foundClueBtn.layer.cornerRadius = 20
    }

}
