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
        OTMClient.getStudents { student, error in
            StudentModel.students = student
            print(student)
        }
        // Do any additional setup after loading the view.
    }


}

