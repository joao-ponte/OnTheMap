//
//  ViewController.swift
//  OnTheMap
//
//  Created by João Ponte on 06/06/2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        OTMClient.getStudents { student, error in
//            StudentModel.students = student
//            print(student)
//        }
        
        OTMClient.postStudents(firstname: "Joao", lastName: "Ponte", latitude: 51.542903452258294, longitude: -0.03975658347538195, mapString: "London", mediaURL: "www.udacity.com") { (success, error) in
            if success {
                print("\(success)🤪")
            } else {
                print("\(String(describing: error))🤪")
            }
        }
        // Do any additional setup after loading the view.
    }


}

