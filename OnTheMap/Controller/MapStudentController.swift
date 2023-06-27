//
//  MapStudentController.swift
//  OnTheMap
//
//  Created by João Ponte on 22/06/2023.
//

import UIKit
import MapKit

class MapStudentController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OTMClient.getStudents { (students, error) in
            if let error = error {
                print("Error fetching students: \(error)")
            } else {
                StudentModel.students = students
                
                let annotations = self.createAnnotations(from: students)
                self.mapView.addAnnotations(annotations)
                self.mapView.delegate = self
            }
        }
    }
    
    @IBAction func addLocation(_ sender: Any) {
    }
    
    @IBAction func pressLogout(_ sender: Any) {
        OTMClient.logout { (_, error) in
            if let error = error {
                print("Logout error: \(error)")
            } else {
                print("logout successful")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
    }
    
    @IBAction func updateList(_ sender: Any) {
        OTMClient.getStudents { (students, _) in
            StudentModel.students = students
        }
    }
    
    
    func mapView(_ mapView: MKMapView,
                 viewFor annotation: MKAnnotation) -> MKAnnotationView? {

        let reuseId = "pin"

        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView

        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }

        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            guard let subtitle = view.annotation?.subtitle, let urlString = subtitle, let url = URL(string: urlString) else {
                print("Invalid URL")
                let alertVC = UIAlertController(title: "Invalid URL", message: "The URL is not valid", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
                return
            }
            
            let app = UIApplication.shared
            if app.canOpenURL(url) {
                app.open(url, options: [:], completionHandler: nil)
            } else {
                print("Unable to open URL")
            }
        }
    }

    func createAnnotations(from students: [Student]) -> [MKPointAnnotation] {
        var annotations = [MKPointAnnotation]()
        
        for student in students {
            let coordinate = CLLocationCoordinate2D(latitude: CLLocationDegrees(student.latitude),
                                                    longitude: CLLocationDegrees(student.longitude))
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(student.firstName) \(student.lastName)"
            annotation.subtitle = student.mediaURL
            annotations.append(annotation)
        }
        
        return annotations
    }
    
}
