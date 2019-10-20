//
//  Batches.swift
//  CollectingEventCompanion
//
//  Created by Warren Brown on 10/15/19.
//  Copyright © 2019 Warren H Brown. All rights reserved.
//

import Foundation

class Batch: Codable {
    var name: String
    var observations: [Observation]
    
    init(name: String, observations: [Observation]?) {
        self.name = name
        if let observations = observations {
            self.observations = observations
        } else {
            self.observations = [Observation]()
        }
    }
    
    static var ArchiveURL: URL {
        get {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let archiveURL = documentDirectory.appendingPathComponent("batches").appendingPathExtension("plist")
            return archiveURL
        }
        
    }
    
    static func saveToFile(batches: [Batch]) {
        let propertyListEncoder = PropertyListEncoder()
        let encodedBatches = try? propertyListEncoder.encode(batches)
        try? encodedBatches?.write(to: self.ArchiveURL, options: .noFileProtection)
    }
    
    static func loadFromFile() -> [Batch]? {
        let propertyDecoder = PropertyListDecoder()
        if let retrievedData = try? Data(contentsOf: self.ArchiveURL),
            let decodedBatches = try? propertyDecoder.decode(Array<Batch>.self, from: retrievedData) {
            return decodedBatches
        }
        return nil
    }
    
}
