//
//  Student.swift
//  OnTheMap
//
//  Created by João Ponte on 06/06/2023.
//

import Foundation

struct Student: Codable {
    let createdAt: String
    let firstName: String
    let lastName: String
    let latitude: Float
    let longitude: Float
    let mapString: String
    let mediaURL: String
    let objectId: String
    let uniqueKey: String?
    let updatedAt: String?
}
