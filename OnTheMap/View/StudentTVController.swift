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
        OTMClient.getStudents { (students, _) in
            StudentModel.students = students
            self.tableView.reloadData()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
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

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = StudentModel.students[indexPath.row]

        guard let url = URL(string: student.mediaURL) else {
            let alertVC = UIAlertController(title: "Invalid URL",
                                            message: "The URL is not valid",
                                            preferredStyle: .alert)

            alertVC.addAction(UIAlertAction(title: "OK",
                                            style: .default,
                                            handler: nil))
            self.present(alertVC, animated: true, completion: nil)
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Unable to open URL")
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
    // MARK: - Private Methods

    private func presentAddLocationAlert() {
        if StudentModel.userHasLocation() {
            let alertVC = UIAlertController(title: "Location Overwrite",
                                            message: "You already have a location. Do you want to overwrite the existing location?",
                                            preferredStyle: .alert)

            alertVC.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            alertVC.addAction(UIAlertAction(title: "Overwrite", style: .destructive) { _ in
                self.performSegue(withIdentifier: "newLocationFromTable", sender: nil)
            })

            present(alertVC, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "newLocationFromTable", sender: nil)
        }
    }
    
    private func updateStudentList() {
        OTMClient.getStudents { (students, _) in
            StudentModel.students = students
        }
    }
}
