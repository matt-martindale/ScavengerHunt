//
//  AddMarkerViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/15/21.
//

import UIKit

class AddMarkerViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var clueTextView: UITextView!
    @IBOutlet weak var scanMarkerBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var finishBtn: UIButton!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.hideKeyboardOnTap()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        errorLabel.alpha = 0.0
    }

    // MARK: - IBActions
    @IBAction func scanMarkerBtnTapped(_ sender: UIButton) {
    }
    
    @IBAction func finishBtnTapped(_ sender: UIButton) {
    }
    
    // MARK: - Methods
    private func setupViews() {
        titleTextField.addBottomBorder()
        titleTextField.layer.cornerRadius = 20
        clueTextView.layer.borderWidth = 2.0
        clueTextView.layer.borderColor = UIColor.orange.cgColor
        clueTextView.backgroundColor = .clear
        clueTextView.layer.cornerRadius = 10
        clueTextView.tintColor = .orange
        scanMarkerBtn.layer.cornerRadius = 20
        errorLabel.alpha = 0.0
        finishBtn.layer.cornerRadius = 20
        finishBtn.layer.borderWidth = 2.0
        finishBtn.layer.borderColor = UIColor.orange.cgColor
    }
}
