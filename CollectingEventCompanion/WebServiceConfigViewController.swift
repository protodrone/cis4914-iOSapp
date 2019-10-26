//
//  WebServiceConfigViewController.swift
//  CollectingEventCompanion
//
//  Created by Warren Brown on 10/22/19.
//  Copyright © 2019 Warren H Brown. All rights reserved.
//

import UIKit

class WebServiceConfigViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let webConfig = webConfig {
            userNameTextField.text = webConfig.userName
            passwordTextField.text = webConfig.password
            addressTextField.text = webConfig.URL
        }
        updateSaveButtonState()
    }
    
    var webConfig: WebServiceConfig?
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    func updateSaveButtonState() {
        let userName = userNameTextField.text ?? ""
        let passwd = passwordTextField.text ?? ""
        let address = addressTextField.text ?? ""
        saveButton.isEnabled = !userName.isEmpty && !passwd.isEmpty && !address.isEmpty
    }

 
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveWebConfig" else { return }
        let userName = userNameTextField.text ?? ""
        let passwd = passwordTextField.text ?? ""
        let address = addressTextField.text ?? ""
        webConfig = WebServiceConfig(userName: userName, password: passwd, URL: address)
    }


}
