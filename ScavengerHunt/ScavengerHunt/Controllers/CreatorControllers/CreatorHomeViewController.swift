//
//  CreatorHomeViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/13/21.
//

import UIKit
import Firebase
import FirebaseAuth

class CreatorHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: - IBOutlets
    
    // MARK: - Properties
    var events: [Event]?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    // MARK: - Methods
    private func setupViews() {
        navigationItem.setHidesBackButton(true, animated: true)
        navigationController?.navigationBar.barTintColor = UIColor.orange
        createBarBtns()
    }
    
    private func createBarBtns() {
        let gear = UIImage(systemName: "gearshape")
        let add  = UIImage(systemName: "plus.circle.fill")
        
        let settingsBtn = UIBarButtonItem(image: gear, style: .plain, target: self, action: #selector(settingsTapped))
        let addBtn      = UIBarButtonItem(image: add, style: .plain, target: self, action: #selector(addEventTapped))
        
        navigationItem.rightBarButtonItems = [settingsBtn, addBtn]
    }
    
    @objc func settingsTapped() {
        do {
            try Auth.auth().signOut()
            
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("Error signing out")
        }
    }
    
    @objc func addEventTapped() {
        // TODO: - Create event
    }
    
    func loadEvents() {
        // TODO: - Load events from Firebase
    }
    
    // MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let events = events {
            return events.count
        } else {
            print("Error loading events")
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.eventsTableViewCell) else {
            return UITableViewCell()
        }
        cell.textLabel?.text = self.events?[indexPath.row].title
        return cell
    }
    
}
