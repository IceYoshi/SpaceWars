//
//  IDCounter.swift
//  SpaceWars
//
//  Created by Mike Pereira on 08/04/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class IDCounter {
    
    private var head = 1
    
    public func nextID() -> Int {
        let id = head
        head += 1
        return id
    }
    
    public func nextIDRange(_ count: Int) -> [Int] {
        var idRange = [Int]()
        if(count < 1) {
            return idRange
        }
        for i in head...(head+count-1) {
            idRange.append(i)
        }
        head += count
        return idRange
    }
    
}
