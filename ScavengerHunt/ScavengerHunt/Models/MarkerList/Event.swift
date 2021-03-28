//
//  Event.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/11/21.
//

import Foundation
import Firebase

class Event: Codable {
    var title: String
    var uid: String
    var markers: MarkerList
    
    init(title: String, uid: String, markers: MarkerList) {
        self.title = title
        self.uid = uid
        self.markers = markers
    }
    
    func createEvent() -> [String: Any] {
        var eventDict: [String:Any] = [:]
        
        eventDict["title"] = self.title
        eventDict["uid"] = self.uid
        eventDict["markers"] = self.markers.createMarkerDictionary()
        
        return eventDict
    }
    
    func deleteEvent(completion: @escaping (Bool) -> (Void)) {
            let db = Firestore.firestore()

            // Delete from "events" collection
        db.collection("events").document(self.uid).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                    completion(false)
                    return
                }
            }

            // Delete from User events array
            if let userID = Auth.auth().currentUser?.uid {
                let userRef = db.collection("users").document(userID)
                userRef.updateData([
                    "events": FieldValue.arrayRemove([self.uid])
                ]) { err in
                        if let err = err {
                        print("Error removing document: \(err)")
                        completion(false)
                        return
                    } else {
                        completion(true)
                    }
                }
            }

        }
    
}

extension Event: CustomStringConvertible {
    var description: String {
        var text = ""

        text += "Title: \(title), UID: \(uid), Markers: \(markers) "
        return text
    }
}
