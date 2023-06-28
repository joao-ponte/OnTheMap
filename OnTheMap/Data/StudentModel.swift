//
//  StudentModel.swift
//  OnTheMap
//
//  Created by João Ponte on 06/06/2023.
//

import Foundation

class StudentModel {
    static var students = [Student]()
    
    static func userHasLocation() -> Bool {
        guard let uniqueKey = OTMClient.Auth.objectId else {
            return false
        }
        
        return students.contains { $0.objectId == uniqueKey }
    }
}


