//
//  NewLocationViewController.swift
//  OnTheMap
//
//  Created by João Ponte on 28/06/2023.
//

import UIKit
import CoreLocation

class NewLocationViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    let textFieldDelegate = TextFieldDelegate()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        locationTextField.text = "Type the city or country here"
        locationTextField.delegate = textFieldDelegate
    }
    
    @IBAction func tapFindOnTheMap(_ sender: Any) {
        performSegue(withIdentifier: "findLocation", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "findLocation",
           let destinationVC = segue.destination as? SubmittedNewLocationViewController,
           let location = locationTextField.text {
            destinationVC.locationText = location
        }
    }
    
    @IBAction func cancelNewLocation(_ sender: Any) {
        dismiss(animated: true)
    }
}
