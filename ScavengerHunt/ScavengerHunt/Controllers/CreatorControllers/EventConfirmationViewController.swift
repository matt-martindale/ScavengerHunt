//
//  EventConfirmationViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/16/21.
//

import UIKit
import Firebase

class EventConfirmationViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var confirmBtn: UIButton!
    
    // MARK: - Properties
    var event: Event?
    var showDelete: Bool = false
    var deleteBarButton = UIBarButtonItem()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - IBActions
    @IBAction func confirmBtnTapped(_ sender: UIButton) {
        Utilites.shared.playSound(sender.tag)
        
        // Create Dictionary from Linked List Event
        guard let event = event else { return }
        let confirmedEvent = event.createEvent()
        
        let db = Firestore.firestore()
        db.collection("events").document(event.uid).setData(confirmedEvent) { error in
            guard error == nil else {
                print("Error writing to FireStore: \(error!.localizedDescription)")
                return
            }
        }
        
        // Add new event to User's events
        if let userID = Auth.auth().currentUser?.uid {
            let userRef = db.collection("users").document(userID)
            userRef.updateData([
                "events": FieldValue.arrayUnion([event.uid])
            ]) { error in
                guard error == nil else {
                    print("Error adding new event to User events")
                    return
                }
            }
        }
        
        // Go back to HomeVC
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Methods
    private func setupViews() {
        setupTitle()
        confirmBtn.layer.cornerRadius = 20
        tableView.isEditing = true
        deleteBarButton.title = "Delete"
        deleteBarButton.style = .plain
        deleteBarButton.target = self
        deleteBarButton.action = #selector(toggleDelete)
        navigationItem.rightBarButtonItem = deleteBarButton
    }
    
    private func setupTitle() {
        title = event?.markers.head != nil ? "\(event!.title)" : "Add Markers"
    }
    
    @objc func toggleDelete() {
        showDelete = !showDelete
        deleteBarButton.title = showDelete ? "Done" : "Edit"
        tableView.reloadData()
    }
    
}

extension EventConfirmationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let event = event else { return 0 }
        return event.markers.getSize
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell"),
              let marker = event?.markers.getMarkerAt(index: indexPath.row) else { return UITableViewCell() }
        let next = marker.next?.title ?? ""
        cell.textLabel?.text = marker.title
        cell.detailTextLabel?.text = next == "" ? "" : "next: \(next)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let event = event else { return }
        // Use custom MarkerList method to reorder Marker Nodes
        event.markers.insert(source: sourceIndexPath.row, atIndex: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        // Hide delete button in edit mode
        return showDelete == true ? .delete : .none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let marker = event?.markers.getMarkerAt(index: indexPath.row) else { return }
        if editingStyle == .delete {
            event?.markers.removeMarker(marker)
            setupTitle()
            tableView.reloadData()
        }
    }
}
