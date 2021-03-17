//
//  EventConfirmationViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/16/21.
//

import UIKit

class EventConfirmationViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var confirmBtn: UIButton!
    
    // MARK: - Properties
    var event: Event?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        title = event?.markers.getMarkerAt(index: 0)?.title
    }
    
    // MARK: - IBActions
    @IBAction func confirmBtnTapped(_ sender: UIButton) {
        Utilites.shared.playSound(sender.tag)
    }
    
    // MARK: - Methods
    private func setupViews() {
        confirmBtn.layer.cornerRadius = 20
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
    
}
