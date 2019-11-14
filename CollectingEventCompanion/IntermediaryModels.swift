//
//  IntermediaryModels.swift
//  CollectingEventCompanion
//
//  Created by Warren Brown on 11/2/19.
//  Copyright © 2019 Warren H Brown. All rights reserved.
//

import Foundation

struct RemoteBatch: Codable {
    var id: Int
    var batchName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case batchName = "batch_name"
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try valueContainer.decode(Int.self, forKey: CodingKeys.id)
        self.batchName = try valueContainer.decode(String.self, forKey: CodingKeys.batchName)
    }
}

struct RemoteObservation: Codable {
    let id: Int?
    let upload_batch: Int
    let observation_name: String
    let lattitude: Double?
    let longitude: Double?
    let gps_datum: String?
    let Text1: String?
    let Text2: String?
    let Text3: String?
    let Int1: Int?
    let Int2: Int?
    let Int3: Int?
    let notes: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case upload_batch
        case observation_name
        case lattitude
        case longitude
        case gps_datum
        case Text1
        case Text2
        case Text3
        case Int1
        case Int2
        case Int3
        case notes
    }
    
    init(from decoder: Decoder) throws {
        let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try valueContainer.decode(Int?.self, forKey: CodingKeys.id)
        self.upload_batch = try valueContainer.decode(Int.self, forKey: CodingKeys.upload_batch)
        self.observation_name = try valueContainer.decode(String.self, forKey: CodingKeys.observation_name)
        self.lattitude = Double(try valueContainer.decode(String.self, forKey: CodingKeys.lattitude))
        self.longitude = Double(try valueContainer.decode(String.self, forKey: CodingKeys.longitude))
        self.gps_datum = try valueContainer.decode(String?.self, forKey: CodingKeys.gps_datum)
        self.Text1 = try valueContainer.decode(String?.self, forKey: CodingKeys.Text1)
        self.Text2 = try valueContainer.decode(String?.self, forKey: CodingKeys.Text2)
        self.Text3 = try valueContainer.decode(String?.self, forKey: CodingKeys.Text3)
        self.Int1 = try valueContainer.decode(Int?.self, forKey: CodingKeys.Int1)
        self.Int2 = try valueContainer.decode(Int?.self, forKey: CodingKeys.Int2)
        self.Int3 = try valueContainer.decode(Int?.self, forKey: CodingKeys.Int3)
        self.notes = try valueContainer.decode(String?.self, forKey: CodingKeys.notes)
    }
    
    init(id: Int?, upload_batch: Int, observation_name: String, lattitude: Double?, longitude: Double?, gps_datum: String?, Text1: String?, Text2: String?, Text3: String?, Int1: Int?, Int2: Int?, Int3: Int?, notes: String?) {
        self.id = id
        self.upload_batch = upload_batch
        self.observation_name = observation_name
        self.lattitude = lattitude
        self.longitude = longitude
        self.gps_datum = gps_datum
        self.Text1 = Text1
        self.Text2 = Text2
        self.Text3 = Text3
        self.Int1 = Int1
        self.Int2 = Int2
        self.Int3 = Int3
        self.notes = notes
    }
}
