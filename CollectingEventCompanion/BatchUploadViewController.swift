//
//  BatchUploadViewController.swift
//  CollectingEventCompanion
//
//  Created by Warren Brown on 10/31/19.
//  Copyright © 2019 Warren H Brown. All rights reserved.
//

import UIKit

class BatchUploadViewController: UIViewController {
    @IBOutlet weak var batchNameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var dismissButton: UIButton!
    
    var batch: Batch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissButton.layer.cornerRadius = 5.0
        batchNameLabel.text = batch?.name
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
        var imagesToUpload = [String: Int]()
        // Add Observations and build image upload dictionary
        for observation in batch.observations {
            let remoteObservation = RemoteObservation(id: nil, upload_batch: remoteBatchId, observation_name: observation.name, lattitude: observation.lattitude, longitude: observation.longitude, gps_datum: observation.gpsDatum, Text1: nil, Text2: nil, Text3: nil, Int1: nil, Int2: nil, Int3: nil, notes: observation.notes)
            RemoteBatchController.shared.createRemoteObservation(forRemoteObservation: remoteObservation) { (statusCode, createdId) in
                DispatchQueue.main.async {
                    if let createdId = createdId {
                        self.resultsLabel.text! += "\nUploaded: \(observation.name) Id: \(createdId)"
                        if let uuid = observation.imageUUIDString {
                            imagesToUpload[uuid] = createdId
                            print("\(uuid) : \(createdId)")
                        } else {
                            print("failed to unwrap imageUUIDString")
                        }
                    } else {
                        self.resultsLabel.text! += "\nUh oh. failed to add \(observation.name)"
                    }
                }
            }
        }
        // Upload Images
        print("image count: \(imagesToUpload.count)")
        print(imagesToUpload)
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
