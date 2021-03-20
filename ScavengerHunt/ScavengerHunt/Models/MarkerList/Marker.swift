//
//  Marker.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/11/21.
//

import Foundation

class Marker: Codable {
    var title: String
    var clue: String
    var uid: String
    var next: Marker?
    weak var prev: Marker?
    
    init(title: String, clue: String, uid: UUID) {
        self.title = title
        self.clue = clue
        self.uid = UUID().uuidString
    }
}
