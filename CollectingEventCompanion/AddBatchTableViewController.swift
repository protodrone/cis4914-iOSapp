//
//  AddBatchTableViewController.swift
//  CollectingEventCompanion
//
//  Created by Warren Brown on 10/19/19.
//  Copyright © 2019 Warren H Brown. All rights reserved.
//

import UIKit

class AddBatchTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        updateSaveButtonState()
    }
    
    var batch: Batch?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var batchNameTextField: UITextField!
    
    @IBAction func trashTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func saveTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    func updateSaveButtonState() {
        let batchNameText = batchNameTextField.text ?? ""
        saveButton.isEnabled = !batchNameText.isEmpty
    }
    
    @IBAction func showFilesButtonTapped(_ sender: Any) {
        listPNGFiles()
    }
    
    func listPNGFiles() {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            let pngFiles = directoryContents.filter{ $0.pathExtension == "png" }
            let pngFileNames = pngFiles.map{ $0.deletingPathExtension().lastPathComponent }
            print(pngFileNames)
            print("\(pngFileNames.count) PNG files")
        }
        catch {
            print(error)
        }
    }
    
    // MARK: - Table view data source
    /*
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
        guard segue.identifier == "saveUnwind" else { return }
        let batchName = batchNameTextField.text ?? ""
        batch = Batch(name: batchName, observations: nil)
    }

}
