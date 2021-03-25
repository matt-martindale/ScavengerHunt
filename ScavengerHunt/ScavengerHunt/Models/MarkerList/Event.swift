//
//  Event.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/11/21.
//

import Foundation

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
    
//    func createLinkedList(from dictionary: [String:Any]) -> Event {
//        
//        // Create Markers
//        let markers = MarkerList()
//        // Iterate through event properties
//        for (eventProp, eventValue) in dictionary {
//            // Get the property with markers
//            if eventProp == "markers" {
//                // Need to create tempDict to force cast eventValue so it can sort
//                let tempDict = eventValue as! [String:[String]]
//                // Create sorted event by dict key
//                let sortedEvent = tempDict.sorted(by: {$0.0 < $1.0})
//                // Iterate through sorted Dict
//                for (index, markerArray) in sortedEvent{
//                    let title = markerArray[0]
//                    let uid = markerArray[1]
//                    let clue = markerArray[2]
//                    
//                    // Need to cast String index as Int
//                    let intIndex = Int(index)
//                    // If it's the first add to the head
//                    if intIndex == 0 {
//                        markers.addToHead(marker: Marker(title: title, clue: clue, uid: uid))
//                        // else just create and add the new marker
//                    } else {
//                        markers.addMarker(marker: Marker(title: title, clue: clue, uid: uid))
//                    }
//                }
//            }
//        }
//        
//        let title = dictionary["title"] as! String
//        let uid = dictionary["uid"] as! String
//        let event = Event(title: title, uid: uid, markers: markers)
//        
//        return event
//    }
    
}

extension Event: CustomStringConvertible {
    var description: String {
        var text = ""

        text += "Title: \(title), UID: \(uid), Markers: \(markers) "
        return text
    }
}
