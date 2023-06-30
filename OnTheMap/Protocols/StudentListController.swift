//
//  StudentListController.swift
//  OnTheMap
//
//  Created by João Ponte on 29/06/2023.
//

import UIKit

protocol StudentListController: UIViewController {
    func presentAddLocationAlert()
    func logout()
    func fetchStudentTableView()
    func presentErrorAlert(message: String)
    func updateStudentList()
    func showUpdateListFailure(message: String)
}

extension StudentListController {
    func presentAddLocationAlert() {
        if StudentModel.userHasLocation() {
            let alertVC = UIAlertController(title: "Location Overwrite",
                                            message: "You already have a location. Do you want to overwrite the existing location?",
                                            preferredStyle: .alert)
            
            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertVC.addAction(UIAlertAction(title: "Overwrite", style: .destructive) { _ in
                self.performSegue(withIdentifier: "newLocation", sender: nil)
            })
            
            present(alertVC, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "newLocation", sender: nil)
        }
    }
    
    func logout() {
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
    
    func updateStudentList() {
        guard reachability?.connection != .unavailable else {
            let errorMessage = "You don't have an internet connection. Please connect to the internet and try again."
            showUpdateListFailure(message: errorMessage)
            return
        }
        
        OTMClient.getStudents { (students, _) in
            if students.isEmpty {
                let errorMessage = "Failed to fetch student data. Please try again later."
                self.showUpdateListFailure(message: errorMessage)
            } else {
                StudentModel.students = students
            }
        }
    }
    
    func showUpdateListFailure(message: String) {
        let alertVC = UIAlertController(title: "Update Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    func fetchStudentTableView() {
        OTMClient.getStudents { (students, error) in
            if let error = error {
                if let decodingError = error as? DecodingError, case .dataCorrupted(let context) = decodingError {
                    let fetchError = FetchStudentError.dataCorrupted(debugDescription: context.debugDescription)
                    self.presentErrorAlert(message: fetchError.errorMessage)
                } else if let fetchError = error as? FetchStudentError {
                    self.presentErrorAlert(message: fetchError.errorMessage)
                } else {
                    self.presentErrorAlert(message: FetchStudentError.otherError.errorMessage)
                }
            } else {
                StudentModel.students = students
            }
        }
    }
    
    func presentErrorAlert(message: String) {
        DispatchQueue.main.async {
            let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    
}
