//
//  AddEditObservationTableViewController.swift
//  CollectingEventCompanion
//
//  Created by Warren Brown on 10/20/19.
//  Copyright © 2019 Warren H Brown. All rights reserved.
//

import UIKit
import CoreLocation

class AddEditObservationTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
        locationManager?.requestWhenInUseAuthorization()
        
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
            if let imageUUIDString = observation.imageUUIDString {
                let fileURL = imgageDirectoryURL.appendingPathComponent(imageUUIDString).appendingPathExtension("png")
                do {
                    let imageData = try Data(contentsOf: fileURL)
                    imageView.image = UIImage(data: imageData)
                    imageURLHolder = fileURL.lastPathComponent.replacingOccurrences(of: ".png", with: "")
                    print("viewDidLoad imageURLHolder : \(imageURLHolder)")
                    imageView.transform = CGAffineTransform(rotationAngle: (180.0 * .pi/2) / 180.0)
                    print("Transform called.")
                    
                } catch {
                    print("Error loading image : \(error)")
                    print("fileURL : \(fileURL)")
                }
            }
        }
        
        updateSaveButtonState()
    }
    //let locationManager = CLLocationManager()
    var observation: Observation?
    var imageURLHolder: String = ""
    var imageNeedsTransform: Bool = false
    var locationManager: CLLocationManager?
    
    @IBOutlet weak var observationNameTextField: UITextField!
    @IBOutlet weak var gpsDatumTextField: UITextField!
    @IBOutlet weak var lattitudeTextField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var commonNameTextField: UITextField!
    @IBOutlet weak var genusTextField: UITextField!
    @IBOutlet weak var speciesTextField: UITextField!
    @IBOutlet weak var notesTextField: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locationImageView: UIImageView!
    
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
    
    @IBAction func locationTapped(_ sender: Any) {
        print("location tapped")
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager?.startUpdatingLocation()
            print("location services updating location")
        } else {
            print("location services not enabled")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("location delegate called")
        guard let location: CLLocationCoordinate2D = manager.location?.coordinate,
             let lattitude = lattitudeTextField.text, let longitude = longitudeTextField.text else { return }
        print("through guard")
        if lattitude.isEmpty && longitude.isEmpty {
            lattitudeTextField.text = String(location.latitude)
            longitudeTextField.text = String(location.longitude)
            gpsDatumTextField.text = "WGS84" // According to Apple docs, all iPhones are fixed to WGS84
            print("lat and long detected as empty")
        } else {
            print("lat and long NOT empty")
        }
        locationManager?.stopUpdatingLocation()
    }
    
    @IBAction func imageViewTapped(_ sender: Any) {
        if let imageIsSymbol = imageView.image?.isSymbolImage {
            imageNeedsTransform = !imageIsSymbol
        }
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { action in
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil) })
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default, handler: { action in imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            })
            alertController.addAction(photoLibraryAction)
        }
        
        // alertController.popoverPresentationController?.sourceView = sender
        present(alertController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else { return }
        imageView.image = selectedImage
        //if !imageNeedsTransform {
            //imageView.transform = CGAffineTransform(rotationAngle: (180.0 * .pi/2) / 180.0)
        //}
        
        // Save image to file
        let uuid = UUID()
        let imageURL = imgageDirectoryURL.appendingPathComponent(uuid.uuidString).appendingPathExtension("png")
        if let imageData = imageView.image?.pngData() {
            try? imageData.write(to: imageURL, options: .atomic)
            imageURLHolder = uuid.uuidString
            print("Image written to : \(imageURL)")
            print("imageURLHolder : \(imageURLHolder)")
        } else {
            print("Error converting to png data.")
        }
                
        
        
        // Fill in code to detect and delete previous image
        self.dismiss(animated: true, completion: nil)
    }
    

    // MARK: - Table view data source
    
    var imgageDirectoryURL: URL {
        get {
            let imageDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            return imageDirectoryURL
        }
        
    }
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
            var imageUUIDString: String?
            if !imageURLHolder.isEmpty {
                imageUUIDString = imageURLHolder
            }
            observation = Observation(name: observationName, gpsDatum: gpsDatum, commonName: commonName, genus: genus, species: species, notes: notes, lattitude: lattitude, longitude: longitude, imageUUIDString: imageUUIDString)
        }
    }

}
