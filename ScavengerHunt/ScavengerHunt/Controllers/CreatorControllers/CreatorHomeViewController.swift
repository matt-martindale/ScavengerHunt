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
    
    lazy var buttonView: UIView = {
        let view = UIView()
        view.frame = CGRect(x: self.view.frame.maxX-100, y: self.view.frame.maxY-180, width: 60, height: 60)
        view.layer.cornerRadius = view.frame.size.width/2
        view.backgroundColor = .white
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 5, height: 5)
        view.layer.shadowRadius = 5
        view.layer.shadowOpacity = 0.3
        return view
    }()
    
    lazy var addEventBtn: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: 5, y: 7, width: 50, height: 45)
        button.setImage(UIImage(systemName: "plus.app.fill"), for: .normal)
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        button.tintColor = .orange
        button.addTarget(self, action: #selector(addEventBtnTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hunts"
        setupViews()
        UserDefaults.standard.set(true, forKey: Constants.inCreatorModeKey)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchEvents()
    }
    
    // MARK: - IBActions
    @objc func addEventBtnTapped(_ sender: UIButton) {
        Utilites.shared.playSound(sender.tag)
        
        guard let createEventVC = storyboard?.instantiateViewController(identifier: Constants.Storyboard.createEventVC) as? CreateEventViewController else { return }
        navigationController?.pushViewController(createEventVC, animated: true)
    }
    
    // MARK: - Methods
    private func setupViews() {
        navigationItem.setHidesBackButton(true, animated: true)
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        view.addSubview(buttonView)
        buttonView.addSubview(addEventBtn)
    }
    
    // Get array of eventIDs from User's events property
    func fetchEvents() {
        // TODO: - Load events from Firebase
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let userEventsRef = db.collection("users").document(userID)
        
        tableView.showActivityIndicator()
        
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
        cell.dashImage.image = Utilites.shared.getDashImage(event)
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let event = self.events[indexPath.row]
            event.deleteEvent { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case true:
                    self.fetchEvents()
                    tableView.reloadData()
                case false:
                    print("Error deleting event")
                }
            }
        }
    }
    
}
