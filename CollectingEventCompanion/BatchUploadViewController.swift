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
    }
    
    @IBAction func dismissButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
