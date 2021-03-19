//
//  MarkerList.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/11/21.
//

import Foundation

class MarkerList: Codable {
    var head: Marker?
    var tail: Marker?
    var size = 0
    
    var isEmpty: Bool {
        return self.head == nil
    }
    
    var getSize: Int {
        return self.size
    }
    
    func addMarker(marker: Marker) {
        if let tailMarker = self.tail {
            marker.prev = tailMarker
            tailMarker.next = marker
        } else {
            self.head = marker
        }
        self.tail = marker
        self.size += 1
    }
    
    func removeMarker(_ marker: Marker) {
        if self.isEmpty { return }
        let prev = marker.prev
        let next = marker.next
        
        if let prev = prev {
            prev.next = next
        } else {
            self.head = next
        }
        
        next?.prev = prev
        
        if next == nil {
            self.tail = prev
        }
        marker.prev = nil
        marker.next = nil
        self.size -= 1
    }
    
    func removeTail() {
        guard let tail = tail else { return }
        if let prev = tail.prev {
            prev.next = nil
            self.tail = prev
        } else {
            self.head = nil
            self.tail = nil
        }
        self.size -= 1
    }
    
    func removeAll() {
        self.head = nil
        self.tail = nil
        self.size = 0
    }
    
    func getMarkerAt(index: Int) -> Marker? {
        if index >= 0 {
            var marker = head
            var i = index
            
            while marker != nil {
                if i == 0 { return marker }
                i -= 1
                marker = marker?.next
            }
        }
        return nil
    }
    
    private func addToHead(marker: Marker) {
        let newMarker = marker
        self.head?.prev = newMarker
        newMarker.next = self.head
        self.head = newMarker
        
        self.size += 1
    }
    
    private func addToTail(marker: Marker) {
        let newMarker = marker
        self.tail?.next = newMarker
        newMarker.prev = self.tail
        self.tail = newMarker
        
        self.size += 1
    }
    
    func insert(source: Int, atIndex: Int) {
        guard atIndex >= 0 && atIndex < self.size else {
            print("Error: Index out of bounds")
            return
        }
        
        guard let sourceMarker = getMarkerAt(index: source) else { return }
        
        removeMarker(sourceMarker)
        
        if atIndex == 0 {
            self.addToHead(marker: sourceMarker)
        } else if atIndex == self.size {
            self.addToTail(marker: sourceMarker)
        } else {
            var curr = self.head
            
            for _ in 0..<atIndex {
                curr = curr?.next
            }
            curr?.prev?.next = sourceMarker
            sourceMarker.prev = curr?.prev
            curr?.prev = sourceMarker
            sourceMarker.next = curr
            self.size += 1
        }
    }
    
    func getDataSource() -> [Marker] {
        var markerArray: [Marker] = []
        var marker = self.head
        
        while marker != nil {
            markerArray.append(marker!)
            marker = marker!.next
        }
        
        return markerArray
    }
    
    func createMarkerDictionary() -> [Int:[String]]? {
        if self.isEmpty == true {
            return nil
        }

        var markerDict = [Int:[String]]()
        var marker = [String]()
        var index = 1
        var node = self.head

        while node != nil {
            marker.append(node!.title)
            marker.append(node!.uid)
            marker.append(node!.clue)
            marker.append(node?.next?.id ?? "")
            marker.append(node?.prev?.id ?? "")
            
            markerDict[index] = marker
            marker = []
            index += 1
            node = node?.next
        }
        return markerDict
    }
    
}

extension MarkerList: CustomStringConvertible {
    var description: String {
        var text = "["
        var node = head

        while node != nil {
            text += "\(node!.title)"
            node = node!.next
            if node != nil { text += ", " }
        }
        return text + "]"
    }
}
