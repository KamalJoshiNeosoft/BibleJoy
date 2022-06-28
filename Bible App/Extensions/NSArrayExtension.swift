//
//  NSArrayExtension.swift
//  Bible App
//
//  Created by webwerks on 22/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation

extension Array {
//    mutating func rotate(positions: Int, size: Int? = nil) {
//        guard positions < count && (size ?? 0) <= count else {
//            print("invalid input1")
//            return
//        }
//        reversed(start: 0, end: positions - 1)
//        reversed(start: positions, end: (size ?? count) - 1)
//        reversed(start: 0, end: (size ?? count) - 1)
//    }
//    mutating func reversed(start: Int, end: Int) {
//        guard start >= 0 && end < count && start < end else {
//            return
//        }
//        var start = start
//        var end = end
//        while start < end, start != end {
//            self.swapAt(start, end)
//            start += 1
//            end -= 1
//        }
//    }
//    mutating func rotate( positions: Int) {
//
//        let positions = positions < 0 ? (self.count - abs(positions) % self.count) : positions % self.count
//
//        if self.count % 2 == 0 {
//            rotateFrom(position: 0, elements: self.count/2, stride: positions)
//            rotateFrom(position: 1, elements: self.count/2, stride: positions)
//        }else{
//            rotateFrom(position: 0, elements: self.count, stride: positions)
//        }
//    }
//
//    private mutating func rotateFrom(position: Int, elements: Int, stride: Int) {
//
//        var counter = elements
//        var index = position
//        var toMove = self[index]
//        while counter > 0
//        {
//            let toSave = self[(index+stride) % self.count]
//            self[(index+stride) % self.count] = toMove
//            toMove = toSave
//            index = (index+stride) % self.count
//            counter-=1
//        }
//    }
    
    func chunks(chunkSize: Int) -> [[Element]] {
        let x =  stride(from: 0, to: self.count, by: chunkSize).map {
            Array(self[$0..<Swift.min($0 + chunkSize, self.count)])
        }
        return x
    }
    
    
    mutating func rotate(positions: Int) {
        let lastIndex = positions - 1
        if lastIndex >= 0, lastIndex < self.count {
            let range = 0...lastIndex
            let newArray = self[range]
            
            self.removeSubrange(range)
            self.append(contentsOf: newArray)
        }
    }
    

}




