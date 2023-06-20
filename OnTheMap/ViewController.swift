//
//  ViewController.swift
//  OnTheMap
//
//  Created by João Ponte on 06/06/2023.
//

import UIKit

class ViewController: UIViewController {
    
    var student: Student!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let username = "joao_ponte@msn.com"
        let password = "talude2011"
        
        OTMClient.loginUser(username: username, password: password) { response, error in
            if let error = error {
                // Handle error
                print("Error: \(error)")
            } else if let response = response {
                // Handle success
                print("Account Key: \(response.account.key)")
                print("Session ID: \(response.session.id)")
            } else {
                // Handle missing response or conversion error
                print("Unknown error occurred")
            }
        }
        
        
        
                OTMClient.getStudents { student, error in
                    StudentModel.students = student
                    print(student)
                }
        
        //        OTMClient.postStudents(firstname: "Joao", lastName: "Ponte", latitude: 51.542903452258294, longitude: -0.03975658347538195, mapString: "London", mediaURL: "www.udacity.com") { (success, error) in
        //            if success {
        //                print("\(success)🤪")
        //            } else {
        //                print("\(String(describing: error))🤪")
        //            }
        //        }
        //        OTMClient.updateStudents(firstname: "Joao", lastName: "Ponte", latitude: 51.542903452258294, longitude: -0.03975658347538195, mapString: "London", mediaURL: "www.udacity.com", objectID: "8ZExGR5uX8") { (success, error) in
        //            if success {
        //                print("\(success)🤪")
        //            } else {
        //                print("\(String(describing: error))🤪")
        //            }
        //        }
        // Do any additional setup after loading the view.
    }
    
    
}

