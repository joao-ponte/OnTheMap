//
//  LoginRequest.swift
//  OnTheMap
//
//  Created by João Ponte on 11/06/2023.
//

import Foundation
struct LoginRequest: Codable {
    struct Udacity: Codable {
        let username: String
        let password: String
    }

    let udacity: Udacity
}
