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
    
    func geocodeLocation(_ location: String) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { [weak self] (placemarks, error) in
            guard let self = self else { return }
            
            if let error = error {
                // Handle geocoding error
                print("Geocoding error:", error.localizedDescription)
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

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? MKPointAnnotation else {
            return
        }

        latitude = annotation.coordinate.latitude
        longitude = annotation.coordinate.longitude
        centerMapOnLocation(annotation.coordinate)
    }

    @IBAction func submitNewLocation(_ sender: Any) {
        guard let location = locationText,
              let mediaURL = linkTextField.text,
              let latitude = latitude,
              let longitude = longitude else {
            return
        }
        
        activityIndicator.startAnimating() // Start activity indicator
        
        let existingStudent = StudentModel.students.first { $0.objectId == OTMClient.Auth.objectId }

        if existingStudent != nil {
            // Update existing student's location
            OTMClient.updateStudent(mapString: location, mediaURL: mediaURL, latitude: Float(latitude), longitude: Float(longitude)) { [weak self] success, error in
                guard let self = self else { return }
                
                self.activityIndicator.stopAnimating() // Stop activity indicator
                
                if success {
                    self.showAlert(title: "Success", message: "The student location was updated successfully", dismissHandler: { [weak self] in
                        self?.dismiss(animated: true)
                    })
                } else {
                    let errorMessage = error?.localizedDescription ?? "Try again!"
                    self.showAlert(title: "Weird", message: errorMessage, dismissHandler: { [weak self] in
                        self?.dismiss(animated: true)
                    })
                }
            }
        } else {
            OTMClient.addStudent(mapString: location, mediaURL: mediaURL, latitude: Float(latitude), longitude: Float(longitude)) { [weak self] success, error in
                guard let self = self else { return }
                
                self.activityIndicator.stopAnimating() // Stop activity indicator
                
                if success {
                    self.showAlert(title: "Success", message: "A student was added successfully", dismissHandler: { [weak self] in
                        self?.dismiss(animated: true)
                    })
                } else {
                    let errorMessage = error?.localizedDescription ?? "Try again!"
                    self.showAlert(title: "Weird", message: errorMessage, dismissHandler: { [weak self] in
                        self?.dismiss(animated: true)
                    })
                }
            }
        }
    }
    
    func showAlert(title: String, message: String, dismissHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "OK", style: .default) { _ in
            dismissHandler?()
        }
        alert.addAction(dismissAction)
        present(alert, animated: true)
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
