//
//  Utilities.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/13/21.
//

import UIKit
import AVFoundation

struct Utilites {
    static var shared = Utilites()
    var player: AVAudioPlayer?
    
    private init() {}
    
    func isPasswordValid(_ password: String) -> Bool? {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@",
                                       "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    func showError(_ message: String, errorLabel: UILabel) {
        errorLabel.text = message
        errorLabel.alpha = 1.0
    }
    
    mutating func playSound(_ senderTag: Int) {
        // Check which button was tapped using Sender's tag
        let resource: String = senderTag == 0 ? "startButton" : "buttonClick"
        
        let path = Bundle.main.path(forResource: resource, ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch {
            print("Couldn't load file")
        }
    }
    
    func getMonsterImage() -> UIImage {
        let monsterNumber = Int.random(in: 1...6)
        return UIImage(named: "monster\(monsterNumber)")!
    }
    
    func getDashImage(_ event: Event) -> UIImage {
        let numOfMarkers = event.markers.getSize
        
        switch numOfMarkers {
        case 1...2:
            return UIImage(named: "dash1")!
        case 3...4:
            return UIImage(named: "dash2")!
        case 5...6:
            return UIImage(named: "dash3")!
        case 7...8:
            return UIImage(named: "dash4")!
        default:
            return UIImage(named: "dash1")!
        }
    }
    
    func createLinkedList(from dictionary: [String:Any]) -> Event {
        
        // Create Markers
        let markers = MarkerList()
        // Iterate through event properties
        for (eventProp, eventValue) in dictionary {
            // Get the property with markers
            if eventProp == "markers" {
                // Need to create tempDict to force cast eventValue so it can sort
                let tempDict = eventValue as! [String:[String]]
                // Create sorted event by dict key
                let sortedEvent = tempDict.sorted(by: {$0.0 < $1.0})
                // Iterate through sorted Dict
                for (index, markerArray) in sortedEvent{
                    let title = markerArray[0]
                    let uid = markerArray[1]
                    let clue = markerArray[2]
                    
                    // Need to cast String index as Int
                    let intIndex = Int(index)
                    // If it's the first add to the head
                    if intIndex == 0 {
                        markers.addToHead(marker: Marker(title: title, clue: clue, uid: uid))
                        // else just create and add the new marker
                    } else {
                        markers.addMarker(marker: Marker(title: title, clue: clue, uid: uid))
                    }
                }
            }
        }
        
        let title = dictionary["title"] as! String
        let uid = dictionary["uid"] as! String
        let event = Event(title: title, uid: uid, markers: markers)
        
        return event
    }
    
}
