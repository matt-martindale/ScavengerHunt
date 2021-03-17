//
//  Event.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/11/21.
//

import Foundation

class Event {
    var title: String
    var uid: String
    var markers: MarkerList
    
    init(title: String, uid: String, markers: MarkerList) {
        self.title = title
        self.uid = uid
        self.markers = markers
    }
}
