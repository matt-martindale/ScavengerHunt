//
//  PlayViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/25/21.
//

import UIKit
import CoreNFC

class PlayViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var clueBoxImageView: UIImageView!
    @IBOutlet weak var clueLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var backbtn: UIButton!
    @IBOutlet weak var foundClueBtn: UIButton!
    
    // MARK: - Properties
    var event: Event?
    lazy var currentMarker: Marker? = event?.markers.head
    var session: NFCNDEFReaderSession?
    
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
        
        // start NFC session
        guard NFCNDEFReaderSession.readingAvailable else {
            Utilites.shared.showError("This device does not support tag scanning.", errorLabel: errorLabel)
            return
        }
        
        session = NFCNDEFReaderSession(delegate: self, queue: DispatchQueue.main, invalidateAfterFirstRead: false)
        session?.alertMessage = "Hold your iPhone near the item to scan"
        session?.begin()
    }
    
    // MARK: - Methods
    func setupViews() {
        self.navigationItem.setHidesBackButton(true, animated: true)
        backbtn.layer.cornerRadius = 20
        backbtn.layer.borderWidth = 2.0
        backbtn.layer.borderColor = UIColor.orange.cgColor
        foundClueBtn.layer.cornerRadius = 20
    }
    
    func loadNextMarker(nextMarkerUID: String) {
        guard let currentMarker = currentMarker else {
            print("No current Marker")
            return }
        
        if self.currentMarker?.next?.next == nil {
            guard let finishVC = (storyboard?.instantiateViewController(identifier: Constants.Storyboard.finishVC)) as? FinishViewController else { return }
            navigationController?.pushViewController(finishVC, animated: true)
        }
        
        // Check if marker scanned is really the next Marker in the Event
        guard currentMarker.next?.uid == nextMarkerUID else {
            Utilites.shared.showError("Whoops! Wrong order. This Tag wasn't the next clue.", errorLabel: errorLabel)
            return
        }
        
        // If next Marker isn't the last one and scanned tag really is next, change current Marker to next one
        self.currentMarker = currentMarker.next
        clueLabel.text = self.currentMarker?.clue
    }
    
}

extension PlayViewController: NFCNDEFReaderSessionDelegate {
    func readerSession(_ session: NFCNDEFReaderSession, didDetectNDEFs messages: [NFCNDEFMessage]) {
        for message in messages {
            for record in message.records {
                if let markerUID = String(data: record.payload, encoding: .utf8) {
                    session.alertMessage = "Scan successful!"
                    
                    // Format markerUID to remove first 2 characters
                    let strippedMarkerUID = String(markerUID.dropFirst(1))
                    session.invalidate()
                    
                    loadNextMarker(nextMarkerUID: strippedMarkerUID)
                } else {
                    // Error with getting payload
                    Utilites.shared.showError("Error getting message payload from tag, \(record.payload)", errorLabel: errorLabel)
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
