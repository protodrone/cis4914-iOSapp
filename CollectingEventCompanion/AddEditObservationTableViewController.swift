//
//  AddEditObservationTableViewController.swift
//  CollectingEventCompanion
//
//  Created by Warren Brown on 10/20/19.
//  Copyright © 2019 Warren H Brown. All rights reserved.
//

import UIKit

class AddEditObservationTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        if let observation = observation {
            observationNameTextField.text = observation.name
            gpsDatumTextField.text = observation.gpsDatum
            if let lat = observation.lattitude {
                lattitudeTextField.text = String(lat)
            }
            if let long = observation.longitude {
                longitudeTextField.text = String(long)
            }
            commonNameTextField.text = observation.commonName
            genusTextField.text = observation.genus
            speciesTextField.text = observation.species
            notesTextField.text = observation.notes
        }
        
        updateSaveButtonState()
    }
    
    var observation: Observation?
    
    @IBOutlet weak var observationNameTextField: UITextField!
    @IBOutlet weak var gpsDatumTextField: UITextField!
    @IBOutlet weak var lattitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var commonNameTextField: UITextField!
    @IBOutlet weak var genusTextField: UITextField!
    @IBOutlet weak var speciesTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextView!
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
       
   func updateSaveButtonState() {
       let observationNameText = observationNameTextField.text ?? ""
       saveButton.isEnabled = !observationNameText.isEmpty
   }

    // MARK: - Table view data source
    /* Static
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "saveObservationUnwind" {
            let observationName = observationNameTextField.text ?? ""
            var gpsDatum: String?
            if let gps = gpsDatumTextField.text {
                gpsDatum = gps
                print("gpsDatum \(gpsDatum!) end")
            }
            var lattitude: Float?
            if let lat = lattitudeTextField.text {
                lattitude = Float(lat)
            }
            var longitude: Float?
            if let long = longitudeTextField.text {
                longitude = Float(long)
            }
            var commonName: String?
            if let cn = commonNameTextField.text {
                commonName = cn
            }
            var genus: String?
            if let genusName = genusTextField.text {
                genus = genusName
            }
            var species: String?
            if let speciesName = speciesTextField.text {
                species = speciesName
            }
            var notes: String?
            if let notesText = notesTextField.text {
                notes = notesText
            }
            observation = Observation(name: observationName, gpsDatum: gpsDatum, commonName: commonName, genus: genus, species: species, notes: notes, lattitude: lattitude, longitude: longitude)
        }
    }

}
