//
//  WebServiceConfig.swift
//  CollectingEventCompanion
//
//  Created by Warren Brown on 10/22/19.
//  Copyright © 2019 Warren H Brown. All rights reserved.
//

import Foundation

class WebServiceConfig: Codable {
    var userName: String
    var password: String
    var URL: String
    
    init(userName: String, password: String, URL: String) {
        self.userName = userName
        self.password = password
        self.URL = URL
    }
    
    static var ArchiveURL: URL {
        get {
            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let archiveURL = documentDirectory.appendingPathComponent("webconfig").appendingPathExtension("plist")
            return archiveURL
        }
        
    }
    
    static func saveToFile(WebServiceConfig: WebServiceConfig) {
        let propertyListEncoder = PropertyListEncoder()
        let encodedBatches = try? propertyListEncoder.encode(WebServiceConfig)
        try? encodedBatches?.write(to: self.ArchiveURL, options: .noFileProtection)
    }
    
    static func loadFromFile() -> WebServiceConfig? {
        let propertyDecoder = PropertyListDecoder()
        if let retrievedData = try? Data(contentsOf: self.ArchiveURL),
            let decodedWebConfig = try? propertyDecoder.decode(WebServiceConfig.self, from: retrievedData) {
            return decodedWebConfig
        }
        return nil
    }
}
