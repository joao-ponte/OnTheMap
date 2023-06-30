//
//  NewLocationViewController.swift
//  OnTheMap
//
//  Created by João Ponte on 28/06/2023.
//

import UIKit
import CoreLocation

class NewLocationViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var locationTextField: UITextField!
    
    let textFieldDelegate = TextFieldDelegate()
    var placemarks: [CLPlacemark]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        locationTextField.text = "Type the city or country here"
        locationTextField.delegate = textFieldDelegate
    }
    
    @IBAction func tapFindOnTheMap(_ sender: Any) {
        geocodeLocation(locationTextField.text ?? "")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "findLocation",
           let destinationVC = segue.destination as? SubmittedNewLocationViewController {
            destinationVC.placemarks = self.placemarks
        }
    }
    
    @IBAction func cancelNewLocation(_ sender: Any) {
        dismiss(animated: true)
    }

    func geocodeLocation(_ location: String) {
        activityIndicator.startAnimating()
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if error != nil {
                Alert.basicAlert(title: "Invalid city or country", message: "Please enter a valid city or country.", vc: self)
            } else {
                self.placemarks = placemarks
                self.performSegue(withIdentifier: "findLocation", sender: nil)
            }
            
            self.activityIndicator.stopAnimating()
        }
    }
}


