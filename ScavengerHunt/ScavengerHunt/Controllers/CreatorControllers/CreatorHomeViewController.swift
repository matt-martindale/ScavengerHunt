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
    var events: [Event] = []
    let db = Firestore.firestore()
    var activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        title = "Events"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchEvents()
    }
    
    // MARK: - Methods
    private func setupViews() {
        navigationItem.setHidesBackButton(true, animated: true)
        createBarBtns()
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
    }
    
    private func createBarBtns() {
        let profile = UIImage(systemName: "person.crop.circle", withConfiguration: UIImage.SymbolConfiguration(weight: .light))?.withTintColor(.orange, renderingMode: .alwaysOriginal)
        let add  = UIImage(systemName: "plus.app.fill")?.withTintColor(.orange, renderingMode: .alwaysOriginal)
        
        let settingsBtn = UIBarButtonItem(image: profile, style: .plain, target: self, action: #selector(settingsTapped))
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
    
    // Get array of eventIDs from User's events property
    func fetchEvents() {
        // TODO: - Load events from Firebase
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let userEventsRef = db.collection("users").document(userID)
        
        tableView.showActivityIndicator()
        
        // --- NEWLY ADDED --- 
        let group = DispatchGroup()
        group.enter()
        // -------------------
        DispatchQueue.global(qos: .default).async {
            userEventsRef.getDocument { [weak self] document, error in
                guard let strongSelf = self else { return }
                guard error == nil else {
                    print("Error retrieving UserEvents: \(error!)")
                    return
                }
                
                if let document = document, document.exists {
                    guard let data = document.data() else { return }
                    strongSelf.loadEvents(data: data)
                    strongSelf.tableView.hideActivityIndicator()
                    group.leave()
                } else {
                    print("Document does not exist")
                }
                // --- NEWLY ADDED ---
//                group.leave()
                // -------------------
            }
        }
        // --- NEWLY ADDED ---
        group.notify(queue: DispatchQueue.main, execute: {
            print("All Done")
            self.tableView.reloadData()
        }) 
        // -------------------
    }
    
    // Load event's data and fill tableView cells with the event's title
    func loadEvents(data: [String: Any]) {
        // Parse User Dictionary to load event data into tableView
        // Create empty array to assign to self.events
        if let eventIDs = data["events"] as? [String] {
            // Clear out events so extra calls don't create duplicate events
            self.events = []
            // Fetch event title
            for eventID in eventIDs {
                fetchEvent(eventID) { result in
                    guard let event = try? result.get() else { return }
                    self.events.append(event)
                     DispatchQueue.main.async {
                         self.tableView.reloadData()
                     }
                }
            }
        } else {
            print("Error parsing dataDictionary")
        }
    }
    
    // Use EventID to fetch the event's title
    func fetchEvent(_ eventID: String, completion: @escaping (Result<Event, Error>) -> Void) {
        let eventRef = db.collection("events").document(eventID)
        
        eventRef.getDocument { event, error in
            guard error == nil else {
                print("Error fetching event title")
                completion(.failure(error!))
                return
            }
            
            if let event = event, event.exists {
                guard let eventData = event.data() else { return }
                let fetchedEvent = Utilites.shared.createLinkedList(from: eventData)
                completion(.success(fetchedEvent))
            } else {
                print("Event does not exist")
                completion(.failure(error!))
                return
            }
        }
    }
    
    // MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.eventsTableViewCell) as? CreatorEventTableViewCell else {
            return UITableViewCell()
        }
        let event = self.events[indexPath.row]
        cell.titleLabel.text = event.title
        cell.finishLabel.text = event.markers.tail?.title
        cell.numberOfMarkersLabel.text = String(event.markers.getSize)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let event  = self.events[indexPath.row]
        
        let creatorStoryboard = UIStoryboard(name: "Creator", bundle: nil)
        guard let eventConfirmationVC = creatorStoryboard.instantiateViewController(identifier: Constants.Storyboard.eventConfirmationVC) as? EventConfirmationViewController else { return }
        eventConfirmationVC.event = event
        navigationController?.pushViewController(eventConfirmationVC, animated: true)
    }
    
    
    
}
