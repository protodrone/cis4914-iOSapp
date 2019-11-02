//
//  RemoteBatchController.swift
//  CollectingEventCompanion
//
//  Created by Warren Brown on 11/2/19.
//  Copyright © 2019 Warren H Brown. All rights reserved.
//

import Foundation

class RemoteBatchController {
    static let shared = RemoteBatchController()
    
    var baseURL: URL? {
        get {
            guard let config = WebServiceConfig.loadFromFile() else { return nil }
            return URL(string: config.URL)!
        }
    }
    
    var base64LoginString: String? {
        get {
            guard let config = WebServiceConfig.loadFromFile() else { return nil }
            let loginString = String(format: "%@:%@", config.userName, config.password).data(using: String.Encoding.utf8)!
            return loginString.base64EncodedString()
        }
    }
    
    var configPresent: Bool {
        get {
            guard WebServiceConfig.loadFromFile() != nil else { return false }
            return true
        }
    }
    
    func fetchRemoteBatches(completion: @escaping ([RemoteBatch]?) -> Void) {
        guard let baseURL = self.baseURL, let base64LoginString = self.base64LoginString else { print("config not found"); return }
        let url = baseURL.appendingPathComponent("batch")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data, let remoteBatch = try? jsonDecoder.decode([RemoteBatch].self, from: data) {
                completion(remoteBatch)
            } else {
                print("unable to unwrap data")
                if let response = response {
                    print("Response: \(response)")
                }
                if let error = error {
                    print("Error: \(error)")
                }
                completion(nil)
            }
        }
        task.resume()
    }
    
    func createRemoteBatch(forBatchName batchName: String, completion: @ escaping (Int?) -> Void) {
        guard let baseURL = self.baseURL, let base64LoginString = self.base64LoginString else { print("config not found"); return }
        let url = baseURL.appendingPathComponent("batch")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data: [String: String] = ["batch_name": batchName]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let response = response {
                guard let httpResponse = response as? HTTPURLResponse else { return }
                print("Create Remote Batch response code: \(httpResponse.statusCode)")
            } else {
                print("Received no response from Create Remote Batch")
            }
            if let data = data,
                let createdRemoteBatch = try? jsonDecoder.decode(RemoteBatch.self, from: data) {
                completion(createdRemoteBatch.id)
            } else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func createRemoteObservation(forRemoteObservation observation: RemoteObservation, completion: @ escaping (Int?, Int?) -> Void){
        guard let baseURL = self.baseURL, let base64LoginString = self.base64LoginString else { print("config not found"); return }
        let url = baseURL.appendingPathComponent("observation")
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64LoginString)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(observation)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request) { (data,response, error) in
            if let data = data, let response = response {
                let jsonDecoder = JSONDecoder()
                do {
                    let createdObservation = try jsonDecoder.decode(RemoteObservation.self, from: data)
                    let httpResponse = response as? HTTPURLResponse
                    completion(httpResponse?.statusCode, createdObservation.id)
                } catch {
                    print (error)
                    completion(nil, nil)
                }
                
            } else {
                print("No response and data from createRemoteObservation")
            }
        }
        task.resume()
    }
}
