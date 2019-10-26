//
//  Observations.swift
//  CollectingEventCompanion
//
//  Created by Warren Brown on 10/14/19.
//  Copyright © 2019 Warren H Brown. All rights reserved.
//

import Foundation
import UIKit

class Observation: Codable {
    var name: String
    var gpsDatum: String?
    var commonName: String?
    var genus: String?
    var species: String?
    var notes: String?
    private var validatedLattitude: Float?
    private var validatedLongitude: Float?
    var imageUUIDString: String?
    
    var lattitude: Float? {
        get {
            return self.validatedLattitude
        }
        set(newLattitude) {
            if let newLattitude = newLattitude {
                if newLattitude >= -90.0 && newLattitude <= 90.0 {
                    self.validatedLattitude = newLattitude
                }
                else {
                    validatedLattitude = nil
                }
            }
        }
    }
    
    var longitude: Float? {
        get {
            return validatedLongitude
        }
        set(newLongitude) {
            if let newLongitude = newLongitude {
                if newLongitude >= -180.0 && newLongitude <= 180.0 {
                    self.validatedLongitude = newLongitude
                } else {
                    validatedLongitude = nil
                }
            }
        }
    }
    
    init(name: String, gpsDatum: String?, commonName: String?, genus: String?, species: String?, notes: String?, lattitude: Float?, longitude: Float?, imageUUIDString: String?) {
        self.name = name
        self.gpsDatum = gpsDatum
        self.commonName = commonName
        self.genus = genus
        self.species = species
        self.notes = notes
        self.lattitude = lattitude
        self.longitude = longitude
        self.imageUUIDString = imageUUIDString
    }
}
