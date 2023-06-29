//
//  MapStudentController.swift
//  OnTheMap
//
//  Created by João Ponte on 22/06/2023.
//

import UIKit
import MapKit

class MapStudentController: UIViewController, StudentListController {

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
        presentAddLocationAlert()
    }

    @IBAction func pressLogout(_ sender: Any) {
        logout()
    }

    @IBAction func updateList(_ sender: Any) {
        updateStudentList()
    }

    // MARK: - Private Methods

    private func createAnnotations(from students: [Student]) -> [MKPointAnnotation] {
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

// MARK: - MKMapViewDelegate

extension MapStudentController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseIdentifier = "annotationView"

        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            annotationView!.canShowCallout = true
            annotationView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            annotationView!.annotation = annotation
        }
        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView, let subtitle = view.annotation?.subtitle, let urlString = subtitle, let url = URL(string: urlString) {
            openURL(for: url)
        }
    }
}
