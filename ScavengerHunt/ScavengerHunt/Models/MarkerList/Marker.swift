//
//  Marker.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/11/21.
//

import Foundation

class Marker {
    var title: String
    var next: Marker?
    weak var prev: Marker?
    
    init(title: String) {
        self.title = title
    }
}
