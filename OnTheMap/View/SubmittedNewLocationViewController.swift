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
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var placemarks: [CLPlacemark]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        linkTextField.text = "Enter a Link to share here"
        linkTextField.delegate = textFieldDelegate
        
        if let placemark = placemarks?.first {
            let annotation = MKPointAnnotation()
            annotation.coordinate = placemark.location!.coordinate
            annotation.title = placemark.name
            self.mapView.addAnnotation(annotation)
            
            self.centerMapOnLocation(placemark.location!.coordinate)
            
            self.latitude = placemark.location!.coordinate.latitude
            self.longitude = placemark.location!.coordinate.longitude
        }
        
        mapView.delegate = self
    }
    
    @IBAction func submitNewLocation(_ sender: Any) {
        guard let location = placemarks?.first?.name,
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
    
    func centerMapOnLocation(_ coordinate: CLLocationCoordinate2D) {
        let regionRadius: CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func cancelNewLocation(_ sender: Any) {
        dismiss(animated: true)
    }
}
