//
//  PlayerFormViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/24/21.
//

import UIKit
import CoreNFC

class PlayerFormViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var firstNameTextField: FloatingLabel!
    @IBOutlet weak var lastNameTextField: FloatingLabel!
    @IBOutlet weak var emailTextField: FloatingLabel!
    @IBOutlet weak var beginBtn: UIButton!
    @IBOutlet weak var beginBtnLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    
    // MARK: - Properties
    var session: NFCNDEFReaderSession?
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: true)
    }
    
    @IBAction func beginBtnTapped(_ sender: UIButton) {
        session?.alertMessage = "Hold your iPhone near the item to scan"
        session?.begin()
        
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
        self.hideKeyboardOnTap()
        self.navigationItem.setHidesBackButton(true, animated: true)
        self.navigationItem.compactAppearance = .none
        firstNameTextField.becomeFirstResponder()
        firstNameTextField.addBottomBorder()
        lastNameTextField.addBottomBorder()
        emailTextField.addBottomBorder()
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        beginBtn.adjustsImageWhenHighlighted = false
        cancelBtn.layer.cornerRadius = 20
        cancelBtn.layer.borderWidth = 2.0
        cancelBtn.layer.borderColor = UIColor.orange.cgColor
        
    }

}

extension PlayerFormViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextTextField = textField.superview?.viewWithTag(textField.tag + 1) as? FloatingLabel {
            nextTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}

extension PlayerFormViewController: NFCNDEFReaderSessionDelegate {
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        for message in messages {
            for record in message.records {
                if let string = String(data: record.payload, encoding: .utf8) {
                    session.alertMessage = "Scan successful!"
                    self.firstNameTextField.text = string
                }
            }
        }
    }
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {
        
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didInvalidateWithError error: Error) {
        // Check the invalidation reason from the returned error.
        if let readerError = error as? NFCReaderError {
            // Show an alert when the invalidation reason is not because of a success read
            // during a single tag read mode, or user canceled a multi-tag read mode session
            // from the UI or programmatically using the invalidate method call.
            if (readerError.code != .readerSessionInvalidationErrorFirstNDEFTagRead)
                && (readerError.code != .readerSessionInvalidationErrorUserCanceled) {
                let alertController = UIAlertController(
                    title: "Session Invalidated",
                    message: error.localizedDescription,
                    preferredStyle: .alert
                )
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
}
