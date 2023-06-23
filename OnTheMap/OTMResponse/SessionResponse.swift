//
//  SessionResponse.swift
//  OnTheMap
//
//  Created by João Ponte on 11/06/2023.
//

import Foundation
struct SessionResponse: Codable {
    struct Account: Codable {
        let registered: Bool
        let key: String
    }

    struct Session: Codable {
        let id: String
        let expiration: String
    }

    let account: Account
    let session: Session
}
