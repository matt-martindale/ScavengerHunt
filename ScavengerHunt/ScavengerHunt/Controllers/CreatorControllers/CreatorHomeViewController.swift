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
    let db = Firestore.firestore()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        title = Auth.auth().currentUser?.email
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchEvents()
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
    
    // Get array of eventIDs from User's events property
    func fetchEvents() {
        // TODO: - Load events from Firebase
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let userEventsRef = db.collection("users").document(userID)
        
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
                } else {
                    print("Document does not exist")
                }
            }
        }
        
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
                fetchEventTitle(eventID) { result in
                    guard let eventTitle = try? result.get() else { return }
                    self.events.append(eventTitle)
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
    func fetchEventTitle(_ eventID: String, completion: @escaping (Result<String, Error>) -> Void) {
        let eventRef = db.collection("events").document(eventID)
        
        eventRef.getDocument { event, error in
            guard error == nil else {
                print("Error fetching event title")
                completion(.failure(error!))
                return
            }
            
            if let event = event, event.exists {
                guard let eventData = event.data() else { return }
                let eventTitle = eventData["title"] as! String
                completion(.success(eventTitle))
            } else {
                print("Event does not exist")
                completion(.failure(error!))
                return
            }
        }
    }
    
    // MARK: - TableView Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if events.count > 0 {
            tableView.backgroundView = nil
            return events.count
        } else {
            let image = UIImage(systemName: "gear")
            let noDataImage = UIImageView(image: image)
            noDataImage.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: tableView.bounds.width)
            noDataImage.contentMode = .scaleAspectFit
            tableView.backgroundView = noDataImage
            tableView.separatorStyle = .none
            
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.eventsTableViewCell) else {
            return UITableViewCell()
        }
        cell.textLabel?.text = self.events[indexPath.row]
        return cell
    }
    
}
