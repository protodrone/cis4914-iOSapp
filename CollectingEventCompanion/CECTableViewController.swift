//
//  CECTableViewController.swift
//  CollectingEventCompanion
//
//  Created by Warren Brown on 10/13/19.
//  Copyright © 2019 Warren H Brown. All rights reserved.
//

import UIKit

class CECTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.cellLayoutMarginsFollowReadableWidth = true
        if let batchesDidLoad = Batch.loadFromFile() {
            self.batches = batchesDidLoad
        }
        if let webConfig = WebServiceConfig.loadFromFile() {
            self.webConfig = webConfig
        }
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        let tableviewEditingMode = tableView.isEditing
        tableView.setEditing(!tableviewEditingMode, animated: true)
    }
    
    // MARK: - Table view data source
    
    var batches: [Batch] = [Batch]()
    var webConfig: WebServiceConfig?

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return batches.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "batchCell", for: indexPath)
        let batch = batches[indexPath.row]
        cell.textLabel?.text = batch.name
        cell.showsReorderControl = true
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            batches.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            Batch.saveToFile(batches: batches)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
  
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedBatch = batches.remove(at: fromIndexPath.row)
        batches.insert(movedBatch, at: to.row)
        Batch.saveToFile(batches: batches)
        tableView.reloadData()
    }


    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BatchDetail" {
            let indexPath = tableView.indexPathForSelectedRow!
            /*
            let navController = segue.destination as! ObservationsTableViewController
            let observationTableViewController = navController.topViewController as! ObservationsTableViewController
            */
            let observationTableViewController = segue.destination as! ObservationsTableViewController
            observationTableViewController.batchIndex = indexPath.row
            observationTableViewController.batches = batches
        }
        
        if segue.identifier == "webConfig" {
            let webConfigViewController = segue.destination as! WebServiceConfigViewController
            webConfigViewController.webConfig = webConfig
        }
        
    }
    
    @IBAction func unwindToCECTableViewcontroller(segue: UIStoryboardSegue) {
        if segue.identifier == "saveUnwind" {
            guard let sourceViewController = segue.source as? AddBatchTableViewController,
                let batch = sourceViewController.batch else { return }
            
            let newIndexPath = IndexPath(row: batches.count, section: 0)
            batches.append(batch)
            tableView.insertRows(at: [newIndexPath], with: .fade)
            Batch.saveToFile(batches: batches)
        }
        
        if segue.identifier == "saveWebConfig" {
            guard let sourceViewController = segue.source as? WebServiceConfigViewController,
                let webConfig = sourceViewController.webConfig else { return }
            WebServiceConfig.saveToFile(WebServiceConfig: webConfig)
            self.webConfig = webConfig
        }
    }

}
