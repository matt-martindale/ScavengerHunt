//
//  Event.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/11/21.
//

import Foundation

class Event {
    var title: String
    var description: String?
    var markers: MarkerList
    
    init(title: String, markers: MarkerList) {
        self.title = title
        self.markers = markers
    }
}
