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
}
