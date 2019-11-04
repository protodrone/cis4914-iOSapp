//
//  BatchUploadViewController.swift
//  CollectingEventCompanion
//
//  Created by Warren Brown on 10/31/19.
//  Copyright © 2019 Warren H Brown. All rights reserved.
//

import UIKit
import Alamofire

class BatchUploadViewController: UIViewController {
    @IBOutlet weak var batchNameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var batch: Batch?
    var imageCounter: Int = 0
    var observationCounter: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissButton.layer.cornerRadius = 5.0
        batchNameLabel.text = batch?.name
        observationCounter = (batch?.observations.count)!
        uploadBatch()
        
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func uploadBatch() {
        guard let batch = self.batch else { print("no batch to upload"); return }
        print("upload batch Id: \(batch.name)")
        
        // Create the remote batch and get the remote batch Id
        RemoteBatchController.shared.createRemoteBatch(forBatchName: batch.name) { (remoteBatchId) in
            DispatchQueue.main.async {
                if let remoteBatchId = remoteBatchId {
                    self.resultsLabel.text = "Remote batch \(remoteBatchId) created."
                    self.uploadObservations(forRemoteBatchId: remoteBatchId)
                } else {
                    self.resultsLabel.text = "Uh oh. Didn't get a remote batch Id."
                }
            }
        }
    }
    
    func uploadObservations(forRemoteBatchId remoteBatchId: Int) {
        guard let batch = self.batch else { print("no batch to upload"); return }
        // Add Observations and build image upload dictionary
        for observation in batch.observations {
            var commonName: String? = nil
            if let cname = observation.commonName  {
                if cname.count > 0 {
                    commonName = cname
                }
            }
            var gps_datum: String? = nil
            if let gpsDatum = observation.gpsDatum {
                if gpsDatum.count > 0 {
                    gps_datum = gpsDatum
                }
            }
            var notes: String? = nil
            if let observationNotes = observation.notes {
                if observationNotes.count > 0 {
                    notes = observationNotes
                }
            }
            let remoteObservation = RemoteObservation(id: nil, upload_batch: remoteBatchId, observation_name: observation.name, lattitude: observation.lattitude, longitude: observation.longitude, gps_datum: gps_datum, Text1: commonName, Text2: nil, Text3: nil, Int1: nil, Int2: nil, Int3: nil, notes: notes)
            RemoteBatchController.shared.createRemoteObservation(forRemoteObservation: remoteObservation) { (statusCode, createdId) in
                DispatchQueue.main.async {
                    if let createdId = createdId {
                        self.resultsLabel.text! += "\nUploaded: \(observation.name) Id: \(createdId)"
                        self.observationCounter -= 1
                        if let uuid = observation.imageUUIDString {
                            self.imageCounter += 1
                            self.uploadImage(withUUID: uuid, forObservation: createdId)
                        } else {
                            print("failed to unwrap imageUUIDString")
                        }
                    } else {
                        self.resultsLabel.text! += "\nUh oh. \(observation.name) failed upload"
                    }
                }
            }
        }
        if observationCounter == 0 && imageCounter == 0 {
            activityIndicator.stopAnimating()
            dismissButton.isEnabled = true
            dismissButton.isHidden = false
            
        }
    }
    
    var imgageDirectoryURL: URL {
        get {
            let imageDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            return imageDirectoryURL
        }
        
    }
    
    // Alomofire upload multipart form data example
    func uploadImage(withUUID uuidString: String, forObservation observationId: Int) {
        self.resultsLabel.text! += "\nStarting image upload for \(observationId)"
        print("upload request for \(uuidString) to observation \(observationId)")
        let fileURL = imgageDirectoryURL.appendingPathComponent(uuidString).appendingPathExtension("png")
        var imageData = Data()
        do {
            imageData = try Data(contentsOf: fileURL)
        } catch {
            print("Error loading image: \(error)")
            print("fileURL: \(fileURL)")
        }
        guard let base64LoginString = RemoteBatchController.shared.base64LoginString else { print("need login string"); return }
        let headers = ["Authorization": "Basic \(base64LoginString)"]
        
        Alamofire.upload(multipartFormData: { multipart in
            multipart.append("\(observationId)".data(using: .utf8)!, withName :"observation")
            multipart.append("\(uuidString)".data(using: .utf8)!, withName: "image_name")
            multipart.append(imageData, withName: "image", fileName: "\(uuidString).png", mimeType: "image/png")
        }, to: "https://tarlington.xyz/api/image", method: .post, headers: headers) { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                print("case .success")
                upload.response { answer in
                    let statusCode = answer.response?.statusCode
                    print("Image \(uuidString) updload statusCode: \(statusCode!)")
                    self.imageCounter -= 1
                    self.resultsLabel.text! += "\nFinished image upload for \(observationId)"
                    if self.observationCounter == 0 && self.imageCounter == 0 {
                        self.activityIndicator.stopAnimating()
                        self.dismissButton.isEnabled = true
                        self.dismissButton.isHidden = false
                    }
                }
                upload.uploadProgress { progress in
                    //call progress callback here if you need it
                }
            case .failure(let encodingError):
                print("case .failure")
                print("multipart upload encodingError: \(encodingError)")
            }
        }
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
