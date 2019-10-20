//
//  ObservationsTableViewController.swift
//  CollectingEventCompanion
//
//  Created by Warren Brown on 10/19/19.
//  Copyright © 2019 Warren H Brown. All rights reserved.
//

import UIKit

class ObservationsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        navigationItem.title = batches[batchIndex].name
    }
    
    @IBAction func editButtonTapped(_ sender: Any) {
        let tableviewEditingMode = tableView.isEditing
        tableView.setEditing(!tableviewEditingMode, animated: true)
    }
    
    var batchIndex: Int = 0
    var batches: [Batch] = [Batch]()
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return batches[batchIndex].observations.count
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "observationCell", for: indexPath)
        let observation = batches[batchIndex].observations[indexPath.row]
        cell.textLabel?.text = observation.name
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

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            batches[batchIndex].observations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            Batch.saveToFile(batches: batches)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        let movedObservatopn = batches[batchIndex].observations.remove(at: fromIndexPath.row)
        batches[batchIndex].observations.insert(movedObservatopn, at: to.row)
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
        if segue.identifier == "editObservation" {
            let indexPath = tableView.indexPathForSelectedRow!
            let observation = batches[batchIndex].observations[indexPath.row]
            let addEditObservationTableViewController = segue.destination as! AddEditObservationTableViewController
            addEditObservationTableViewController.observation = observation
            
        }
    }
    
    @IBAction func unwindAddEditObservationViewcontroller(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveObservationUnwind",
            let sourceViewController = segue.source as? AddEditObservationTableViewController,
            let observation = sourceViewController.observation else { return }
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            // Udpate existing observation
            batches[batchIndex].observations[selectedIndexPath.row] = observation
            tableView.reloadRows(at: [selectedIndexPath], with: .fade)
            Batch.saveToFile(batches: batches)
        } else {
            // Insert new observation
            let newIndexPath = IndexPath(row: batches[batchIndex].observations.count, section: 0)
            batches[batchIndex].observations.append(observation)
            tableView.insertRows(at: [newIndexPath], with: .fade)
            Batch.saveToFile(batches: batches)
        }
        
       
        
    }

}
