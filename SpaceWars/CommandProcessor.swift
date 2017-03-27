//
//  CommandProcessor.swift
//  SpaceWars
//
//  Created by Mike Pereira on 26/03/2017.
//  Copyright © 2017 Mike Pereira. All rights reserved.
//

import SpriteKit

class CommandProcessor {
    
    private var commandDictionary = [String: Command]()
    
    func register(key: String, command: Command) {
        commandDictionary[key] = command
    }
    
    func interpret(data: Data) {
        do {
            let dataJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            if let type = dataJSON?["type"] as? String {
                if let cmd = commandDictionary[type] {
                    cmd.process(dataJSON!)
                } else {
                    print("CommandProcessor: Command \(type) is not registered. Ignoring request.")
                }
            } else {
                print("CommandProcessor: Unexpected JSON structure (missing 'type' key). Ignoring request. Raw data: \(String(data: data, encoding: .utf8)!)")
            }
        } catch {
            print("CommandProcessor: Error while parsing data as JSON in the interpretation step. Raw data: \(String(data: data, encoding: .utf8)!)")
        }
    }
    
}
