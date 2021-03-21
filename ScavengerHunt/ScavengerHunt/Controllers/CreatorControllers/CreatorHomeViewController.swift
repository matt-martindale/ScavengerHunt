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
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Properties
    var events: [String] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        title = Auth.auth().currentUser?.displayName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchEvents()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    // MARK: - Methods
    private func setupViews() {
        navigationItem.setHidesBackButton(true, animated: true)
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
            if Auth.auth().currentUser == nil {
                UserDefaults.standard.removeObject(forKey: Constants.userUIDKey)
                UserDefaults.standard.synchronize()
            }
            
            navigationController?.popToRootViewController(animated: true)
        } catch {
            print("Error signing out")
        }
    }
    
    @objc func addEventTapped() {
        guard let createEventVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.createEventVC) as? CreateEventViewController else { return }
        navigationController?.pushViewController(createEventVC, animated: true)
    }
    
    func fetchEvents() {
        // TODO: - Load events from Firebase
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let userEventsRef = db.collection("users").document(userID)
        
        userEventsRef.getDocument { [weak self] document, error in
            guard let strongSelf = self else { return }
            guard error == nil else {
                print("Error retrieving UserEvents: \(error!)")
                return
            }
            
            if let document = document, document.exists {
                guard let data = document.data() else { return }
                strongSelf.loadEvents(data: data)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func loadEvents(data: [String: Any]) {
        // Parse User Dictionary to load event data into tableView
        // Create empty array to assign to self.events
        if let eventTitles = data["events"] as? [String] {
            eventTitles.forEach { self.events.append($0) }
        } else {
            print("Error parsing dataDictionary")
        }
        
        tableView.reloadData()
    }
    
    // MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.eventsTableViewCell) else {
            return UITableViewCell()
        }
        cell.textLabel?.text = self.events[indexPath.row]
        return cell
    }
    
}
