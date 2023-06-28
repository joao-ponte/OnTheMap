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
        presentAddLocationAlert()
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
        updateStudentList()
    }

    // MARK: - MKMapViewDelegate

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

    // MARK: - Private Methods

    private func presentAddLocationAlert() {
        if StudentModel.userHasLocation() {
            let alertVC = UIAlertController(title: "Location Overwrite",
                                            message: "You already have a location. Do you want to overwrite the existing location?",
                                            preferredStyle: .alert)

            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertVC.addAction(UIAlertAction(title: "Overwrite", style: .destructive) { _ in
                self.performSegue(withIdentifier: "newLocationFromMap", sender: nil)
            })

            present(alertVC, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "newLocationFromMap", sender: nil)
        }
    }

    private func updateStudentList() {
        OTMClient.getStudents { (students, _) in
            StudentModel.students = students
        }
    }

    private func openURL(for url: URL) {
        let app = UIApplication.shared
        if app.canOpenURL(url) {
            app.open(url, options: [:], completionHandler: nil)
        } else {
            print("Unable to open URL")
        }
    }

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
