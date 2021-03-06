//
//  CreateEventViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/14/21.
//

import UIKit
import CoreNFC

class CreateEventViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var firstClueTextView: UITextView!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - Properties
    var session: NFCNDEFReaderSession?
    var uid: NFCNDEFMessage?
    var event: Event?
    
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
    @IBAction func confirmBtnTapped(_ sender: UIButton) {
        Utilites.shared.playSound(sender.tag)
        
        let error = validateFields()
        if let error = error {
            Utilites.shared.showError(error, errorLabel: errorLabel)
            return
        }
        
        // Start NfC reader session
        guard NFCNDEFReaderSession.readingAvailable else {
            Utilites.shared.showError("This device does not support tag scanning.", errorLabel: errorLabel)
            return
        }
        
        session = NFCNDEFReaderSession(delegate: self, queue: nil, invalidateAfterFirstRead: true)
        session?.alertMessage = "Hold your iPhone near the item to scan."
        session?.begin()
        
        // Create Event and write UID to tag
        let uid = UUID()
        let event = Event(title: titleTextField.text!, uid: uid.uuidString, markers: MarkerList())
        event.markers.addMarker(marker: Marker(title: "Start", clue: firstClueTextView.text, uid: uid.uuidString))
        self.event = event
        
        // Create NDEF Payload and update self.uid with Message
        guard let payload = NFCNDEFPayload.wellKnownTypeURIPayload(string: uid.uuidString) else { return }
        self.uid = NFCNDEFMessage.init(records: [payload])
    }
    
    // MARK: - Methods
    private func setupViews() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.prefersLargeTitles = true
        titleTextField.layer.cornerRadius = 20
        titleTextField.addBottomBorder()
        firstClueTextView.layer.borderWidth = 2.0
        firstClueTextView.layer.borderColor = UIColor.orange.cgColor
        firstClueTextView.backgroundColor = .clear
        firstClueTextView.layer.cornerRadius = 10
        firstClueTextView.tintColor = .orange
        confirmBtn.layer.cornerRadius = 20
        errorLabel.alpha = 0.0
    }
    
    private func validateFields() -> String? {
        if titleTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            firstClueTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please fill in all fields."
        } else {
            return nil
        }
    }
    
    private func navigateToAddMarker() {
        let creatorStoryboard = UIStoryboard(name: "Creator", bundle: nil)
        guard let addMarkerVC = creatorStoryboard.instantiateViewController(identifier: Constants.Storyboard.addMarkerVC) as? AddMarkerViewController else { return }
        addMarkerVC.event = self.event
        navigationController?.pushViewController(addMarkerVC, animated: true)
    }
    
}

extension CreateEventViewController: NFCNDEFReaderSessionDelegate {
    
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
        session.connect(to: tag) { error in
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
                    guard let uid = self.uid else { return }
                    tag.writeNDEF(uid) { error in
                        if error != nil {
                            session.alertMessage = "Write NDEF message fail: \(error!)"
                            session.invalidate()
                        } else {
                            session.alertMessage = "Write NDEF message successful."
                            session.invalidate()
                            // Navigate to AddMarkerVC
                            DispatchQueue.main.async {
                                self.navigateToAddMarker()
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
