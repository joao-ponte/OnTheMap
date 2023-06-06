//
//  PostStudent.swift
//  OnTheMap
//
//  Created by João Ponte on 06/06/2023.
//

import Foundation

struct PostStudent: Codable {
    let firstName: String
    let lastName: String
    let latitude: Float
    let longitude: Float
    let mapString: String
    let mediaURL: String
    let uniqueKey: String?
}
