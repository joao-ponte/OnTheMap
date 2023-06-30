//
//  StudentTVController.swift
//  OnTheMap
//
//  Created by João Ponte on 21/06/2023.
//

import UIKit

class StudentTVController: UIViewController, StudentListController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchStudentTableView()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
}

// MARK: - UITableViewDataSource

extension StudentTVController: UITableViewDataSource {
    
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

// MARK: - UITableViewDelegate

extension StudentTVController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = StudentModel.students[indexPath.row]
        
        if let url = URL(string: student.mediaURL) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                Alert.basicAlert(title: "Unable to Open URL", message: "The URL cannot be opened", vc: self)
            }
        } else {
            Alert.basicAlert(title: "Invalid URL", message: "The URL is not valid", vc: self)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
