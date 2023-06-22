//
//  StudentTVController.swift
//  OnTheMap
//
//  Created by João Ponte on 21/06/2023.
//

import UIKit

class StudentTVController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        OTMClient.getStudents { (students, error) in
            StudentModel.students = students
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    @IBAction func addLocation(_ sender: Any) {
    }
    
    @IBAction func pressLogout(_ sender: Any) {
    }
    
    @IBAction func updateList(_ sender: Any) {
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Number of rows: \(StudentModel.students.count)")
        return StudentModel.students.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell")!
        let students = StudentModel.students[indexPath.row]
        cell.textLabel?.text = students.firstName + " " + students.lastName
        cell.detailTextLabel?.text = students.mediaURL
        return cell
    }
}

