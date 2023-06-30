//
//  SubmittedNewLocationViewController.swift
//  OnTheMap
//
//  Created by João Ponte on 28/06/2023.
//

import UIKit
import MapKit

class SubmittedNewLocationViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let textFieldDelegate = TextFieldDelegate()
    var locationText: String?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        linkTextField.text = "Enter a Link to share here"
        if locationText != nil {
        }
        linkTextField.delegate = textFieldDelegate
        
        if let locationText = locationText {
            geocodeLocation(locationText)
        }
        
        mapView.delegate = self
    }
    
    @IBAction func submitNewLocation(_ sender: Any) {
        guard let location = locationText,
              let mediaURL = linkTextField.text,
              let latitude = latitude,
              let longitude = longitude else {
            return
        }
        
        activityIndicator.startAnimating()
        
        let existingStudent = StudentModel.students.first { $0.objectId == OTMClient.Auth.objectId }
        
        if existingStudent != nil {
            OTMClient.updateStudent(mapString: location, mediaURL: mediaURL, latitude: Float(latitude), longitude: Float(longitude)) { [weak self] success, error in
                guard let self = self else { return }
                
                activityIndicator.stopAnimating() // Stop activity indicator
                
                if success {
                    Alert.dismissAlert(title: "Success", message: "The student location was updated successfully", vc: self)
                } else {
                    let errorMessage = error?.localizedDescription ?? "Try again!"
                    Alert.dismissAlert(title: "Weird", message: errorMessage, vc: self)
                }
            }
        } else {
            OTMClient.addStudent(mapString: location, mediaURL: mediaURL, latitude: Float(latitude), longitude: Float(longitude)) { [weak self] success, error in
                guard let self = self else { return }
                
                activityIndicator.stopAnimating()
                
                if success {
                    Alert.dismissAlert(title: "Success", message: "A student was added successfully", vc: self)
                } else {
                    let errorMessage = error?.localizedDescription ?? "Try again!"
                    Alert.dismissAlert(title: "Weird", message: errorMessage, vc: self)
                }
            }
        }
    }
    
    func geocodeLocation(_ location: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if error != nil {
                Alert.dismissAlert(title: "Invalid city or country", message: "Please enter a valid city or country.", vc: self)
                return
            }
            if let placemark = placemarks?.first {
                let annotation = MKPointAnnotation()
                annotation.coordinate = placemark.location!.coordinate
                annotation.title = placemark.name
                self.mapView.addAnnotation(annotation)
                
                self.centerMapOnLocation(placemark.location!.coordinate)
                
                self.latitude = placemark.location!.coordinate.latitude
                self.longitude = placemark.location!.coordinate.longitude
            }
        }
    }
    
    func centerMapOnLocation(_ coordinate: CLLocationCoordinate2D) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func cancelNewLocation(_ sender: Any) {
        dismiss(animated: true)
    }
}
