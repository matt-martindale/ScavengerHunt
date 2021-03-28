//
//  PlayerFormViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/24/21.
//

import UIKit
import CoreNFC
import Firebase

class PlayerFormViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var firstNameTextField: FloatingLabel!
    @IBOutlet weak var lastNameTextField: FloatingLabel!
    @IBOutlet weak var emailTextField: FloatingLabel!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var beginBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    // MARK: - Properties
    var session: NFCNDEFReaderSession?
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        errorLabel.alpha = 0.0
    }
    
    @IBAction func beginBtnTapped(_ sender: UIButton) {
        
        guard NFCNDEFReaderSession.readingAvailable else {
            Utilites.shared.showError("This device does not support tag scanning.", errorLabel: errorLabel)
            return
        }
        
        session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: false)
        session?.alertMessage = "Hold your iPhone near the item to scan"
        session?.begin()
    }
    
    @IBAction func beginBtnHeld(_ sender: UIButton) {
        Utilites.shared.playSound(sender.tag)
        
        beginBtn.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.1, initialSpringVelocity: 1.0, options: UIView.AnimationOptions.allowUserInteraction, animations: { [weak self] in
            guard let self = self else { return }
            self.beginBtn.transform = CGAffineTransform.identity
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
        firstNameTextField.addBottomBorder()
        lastNameTextField.addBottomBorder()
        emailTextField.addBottomBorder()
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        errorLabel.alpha = 0.0
        beginBtn.adjustsImageWhenHighlighted = false
        cancelBtn.layer.cornerRadius = 20
        cancelBtn.layer.borderWidth = 2.0
        cancelBtn.layer.borderColor = UIColor.orange.cgColor
        
    }
    
    func fetchEvent(uid: String, completion: @escaping (Result<Event, Error>) -> Void) {
        
        defer {
            session?.invalidate()
        }
        
        let db = Firestore.firestore()
        
        db.collection("events").document(uid).getDocument { [weak self] document, error in
            guard let self = self else { return }
            
            guard error == nil else {
                print("Error getting document")
                completion(.failure(error!))
                return
            }
            
            if let document = document, document.exists {
                guard let data = document.data() else {
                    print("Error encoding Data")
                    completion(.failure(error!))
                    return
                }
                
                // Turn Dictionary Data into Event
                let event = Utilites.shared.createLinkedList(from: data)
                completion(.success(event))
            } else {
                // TODO: Handle if User scans marker other than First marker
                Utilites.shared.showError("Could not find Scavenger Hunt.\nPlease scan the event's \"Start\" tag.", errorLabel: self.errorLabel)
            }
        }
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
                if let eventUID = String(data: record.payload, encoding: .utf8) {
                    session.alertMessage = "Scan successful!"
                    
                    // Format eventUID to remove first 2 characters
                    let strippedEventUID = String(eventUID.dropFirst(1))
                    
                    // Fetch event with NDEF message
                    fetchEvent(uid: strippedEventUID) { [weak self] result in
                        guard let self = self else { return }
                        
                        guard let event = try? result.get() else {
                            print("Error getting event from UID")
                            return
                        }
                        let playVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.playVC) as! PlayViewController
                        playVC.event = event
                        self.navigationController?.pushViewController(playVC, animated: true)
                        
                    }
                }
            }
        }
    }
    
    func readerSessionDidBecomeActive(_ session: NFCNDEFReaderSession) {} // Implemented to quiet the warnings
    
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
