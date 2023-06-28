//
//  User.swift
//  OnTheMap
//
//  Created by João Ponte on 28/06/2023.
//

import Foundation
struct User: Codable {

    let lastName: String
    let firstName: String

    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case firstName = "first_name"
    }
}
