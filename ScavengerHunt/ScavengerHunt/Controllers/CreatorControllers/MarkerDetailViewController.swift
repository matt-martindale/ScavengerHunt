//
//  MarkerDetailViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 4/28/21.
//

import UIKit

protocol MarkerUpdateDelegate {
    func updateMarker(title: String, clue: String)
}

class MarkerDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var clueTextView: UITextView!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - Properties
    var marker: Marker?
    var markerDelegate: MarkerUpdateDelegate!
    
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
    
    private func validateFields() -> String? {
        if titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            clueTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        } else {
            return nil
        }
    }

    // MARK: - IBActions
    @IBAction func saveBtnTapped(_ sender: UIButton) {
        Utilites.shared.playSound(sender.tag)
        
        // Check if the fields aren't empty
        let error = validateFields()
        if let error = error {
            Utilites.shared.showError(error, errorLabel: errorLabel)
            return
        }
        
        // Call delegate method to update passed in marker
        guard let title = titleTextField.text,
              let clue = clueTextView.text else { return }
        markerDelegate.updateMarker(title: title, clue: clue)
        navigationController?.popViewController(animated: true)
    }
}
