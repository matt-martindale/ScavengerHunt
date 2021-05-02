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
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
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
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        errorLabel.alpha = 0.0
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
        guard let controllers = navigationController?.viewControllers else { return }
        for vc in controllers {
            if vc is CreatorTabViewController {
                _ = navigationController?.popToViewController(vc as! CreatorTabViewController, animated: true)
            }
        }
    }
    
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        Utilites.shared.playSound(sender.tag)
        
        // Go back to HomeVC
        guard let controllers = navigationController?.viewControllers else { return }
        for vc in controllers {
            if vc is CreatorTabViewController {
                _ = navigationController?.popToViewController(vc as! CreatorTabViewController, animated: true)
            }
        }
    }
    
    
    // MARK: - Methods
    private func setupViews() {
        setupTitle()
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        confirmBtn.layer.cornerRadius = 20
        tableView.isEditing = true
        tableView.allowsSelectionDuringEditing = true
        deleteBarButton.title = "Edit"
        deleteBarButton.style = .plain
        deleteBarButton.target = self
        deleteBarButton.action = #selector(toggleDelete)
        errorLabel.alpha = 0.0
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? EventDetailTableViewCell,
              let marker = event?.markers.getMarkerAt(index: indexPath.row) else { return UITableViewCell() }
        let next = marker.next?.title ?? ""
        cell.titleLabel.text = marker.title
        cell.clueLabel.text = marker.clue
        
        let attributedNextString = NSMutableAttributedString(string: "Next: \(next)")
        attributedNextString.addAttribute(.foregroundColor, value: UIColor.orange, range: NSRange(location: 0, length: 5))
        
        cell.nextLabel.attributedText = next == "" ? NSAttributedString(string: "") : attributedNextString
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 0 ? true : false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let event = event else { return }
        
        // Check if User is trying to swap first marker. If so, undo their swap by reversing the insert
        if destinationIndexPath.row == 0 {
            event.markers.insert(source: destinationIndexPath.row, atIndex: sourceIndexPath.row)
            Utilites.shared.showError("Can't swap Start marker", errorLabel: errorLabel)
            
            // Create timer to hide error after a certain time
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
                guard let self = self else { return }
                self.errorLabel.alpha = 0.0
            }
        }
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let index = indexPath.row
        guard let marker = event?.markers.getMarkerAt(index: index) else {
            print("Could not find marker at index: \(index)")
            return
        }
        
        let creatorStoryboard = UIStoryboard(name: "Creator", bundle: nil)
        guard let editMarkerVC = creatorStoryboard.instantiateViewController(identifier: Constants.Storyboard.editMarkerVC) as? MarkerDetailViewController else { return }
        editMarkerVC.marker = marker
        editMarkerVC.index = index
        editMarkerVC.markerDelegate = self
        navigationController?.pushViewController(editMarkerVC, animated: true)
        
    }
}

extension EventConfirmationViewController: MarkerUpdateDelegate {
    func updateMarker(title: String, clue: String, index: Int) {
        let marker = event?.markers.getMarkerAt(index: index)
        marker?.title = title
        marker?.clue = clue
        tableView.reloadData()
    }
}
