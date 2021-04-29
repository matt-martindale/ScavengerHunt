//
//  MarkerDetailViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 4/28/21.
//

import UIKit

class MarkerDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var clueTextView: UITextView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - Properties
    var marker: Marker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTextFields()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        errorLabel.alpha = 0.0
    }
    
    private func setupTextFields() {
        guard let marker = marker else { return }
        titleTextField.text = marker.title
        clueTextView.text = marker.clue
    }
    
    private func setupViews() {
        titleTextField.layer.cornerRadius = 20
        titleTextField.addBottomBorder()
        clueTextView.layer.borderWidth = 2.0
        clueTextView.layer.borderColor = UIColor.orange.cgColor
        clueTextView.backgroundColor = .clear
        clueTextView.layer.cornerRadius = 10
        clueTextView.tintColor = .orange
        saveBtn.layer.cornerRadius = 20
        errorLabel.alpha = 0.0
    }

    @IBAction func saveBtnTapped(_ sender: UIButton) {
        Utilites.shared.playSound(sender.tag)
    }
}
