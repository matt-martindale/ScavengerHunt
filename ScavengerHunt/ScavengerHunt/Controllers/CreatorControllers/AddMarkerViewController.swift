//
//  AddMarkerViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/15/21.
//

import UIKit
import CoreNFC

class AddMarkerViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var clueTextView: UITextView!
    @IBOutlet weak var scanMarkerBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var finishBtn: UIButton!
    
    // MARK: - Properties
    var event: Event?
    var session: NFCNDEFReaderSession?
    var uid: NFCNDEFMessage?
    var eventUID: UUID?
    var cluePlaceholderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.4)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        self.hideKeyboardOnTap()
        clueTextView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let event = event else { return }
        title = "Add Marker# \(event.markers.getSize+1)"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        errorLabel.alpha = 0.0
    }

    // MARK: - IBActions
    @IBAction func scanMarkerBtnTapped(_ sender: UIButton) {
        Utilites.shared.playSound(sender.tag)
        // Validate fields
        let error = validateFields()
        if let error = error {
            Utilites.shared.showError(error, errorLabel: errorLabel)
            return
        }
        
        // Start NFC reader session
        guard NFCNDEFReaderSession.readingAvailable else {
            Utilites.shared.showError("This device does not support tag scanning.", errorLabel: errorLabel)
            return
        }
        
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        session?.alertMessage = "Hold your iPhone near the item to scan."
        session?.begin()
        
        // Create NDEF Payload and update self.uid with message
        let uid = UUID()
        guard let payload = NFCNDEFPayload.wellKnownTypeURIPayload(string: uid.uuidString) else { return }
        self.uid = NFCNDEFMessage(records: [payload])
        self.eventUID = uid
    }
    
    @IBAction func finishBtnTapped(_ sender: UIButton) {
        let creatorStoryboard = UIStoryboard(name: "Creator", bundle: nil)
        guard let eventConfirmationVC = creatorStoryboard.instantiateViewController(identifier: Constants.Storyboard.eventConfirmationVC) as? EventConfirmationViewController else { return }
        eventConfirmationVC.event = self.event
        navigationController?.pushViewController(eventConfirmationVC, animated: true)
        
    }
    
    // MARK: - Methods
    private func setupViews() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        titleTextField.addBottomBorder()
        titleTextField.layer.cornerRadius = 20
        clueTextView.layer.borderWidth = 2.0
        clueTextView.layer.borderColor = UIColor.orange.cgColor
        clueTextView.backgroundColor = .clear
        clueTextView.layer.cornerRadius = 10
        clueTextView.tintColor = .orange
        clueTextView.textColor = cluePlaceholderColor
        scanMarkerBtn.layer.cornerRadius = 20
        errorLabel.alpha = 0.0
        finishBtn.layer.cornerRadius = 20
        finishBtn.layer.borderWidth = 2.0
        finishBtn.layer.borderColor = UIColor.orange.cgColor
    }
    
    private func validateFields() -> String? {
        if titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            clueTextView.text.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields"
        } else {
            return nil
        }
    }
    
    func clearValues() {
        guard let event = event else { return }
        title = "Add Marker #\(event.markers.getSize+1)"
        titleTextField.text = ""
        clueTextView.text = "*Write clue to next marker*"
    }
    
    func createEvent() {
        // Append Marker to Event and write Marker UID to tag
        guard let uid = self.eventUID else { return }
        let marker = Marker(title: titleTextField.text!, clue: clueTextView.text!, uid: uid.uuidString)
        self.event?.markers.addMarker(marker: marker)
    }
    
    func showSuccessAlert() {
        let alert = UIAlertController(title: "Success", message: "Your Clue was successfully written. You can now add another marker.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: nil)
    }
    
}

extension AddMarkerViewController: NFCNDEFReaderSessionDelegate {
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
    }
    
    func readerSession(_ session: NFCNDEFReaderSession, didDetect tags: [NFCNDEFTag]) {
        if tags.count > 1 {
            let retryInterval = DispatchTimeInterval.milliseconds(500)
            session.alertMessage = "More than 1 tag was detected. Please remove all tags and try again."
            DispatchQueue.global().asyncAfter(deadline: .now() + retryInterval, execute: {
                session.restartPolling()
            })
            return
        }
        
        // Connect to the found tag and write an NDEF message to it
        let tag = tags.first!
        session.connect(to: tag) { [weak self] error in
            guard let strongSelf = self else { return }
            if error != nil {
                session.alertMessage = "Unable to connect to tag."
                session.invalidate()
                return
            }
            
            tag.queryNDEFStatus { (ndefStatus, capacity, error) in
                guard error == nil else {
                    session.alertMessage = "Unable to query the NDEF status of tag."
                    session.invalidate()
                    return
                }
                switch ndefStatus {
                case .notSupported:
                    session.alertMessage = "Tag is not NDEF compliant"
                    session.invalidate()
                case .readOnly:
                    session.alertMessage = "Tag is a read-only"
                    session.invalidate()
                case .readWrite:
                    guard let uid = strongSelf.uid else { return }
                    tag.writeNDEF(uid) { error in
                        if error != nil {
                            session.alertMessage = "Write NDEF message fail: \(error!)"
                            session.invalidate()
                        } else {
                            session.alertMessage = "Write NDEF message successful."
                            session.invalidate()
                            // Upon successful write clear out current values
                            DispatchQueue.main.async {
                                strongSelf.createEvent()
                                strongSelf.clearValues()
                                strongSelf.showSuccessAlert()
                            }
                        }
                    }
                @unknown default:
                    session.alertMessage = "Unknown NDEF tag status."
                    session.invalidate()
                }
            }
        }
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

extension AddMarkerViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == cluePlaceholderColor {
            textView.text = nil
            textView.textColor = .white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Clue to next marker"
            textView.textColor = cluePlaceholderColor
        }
    }
    
}
