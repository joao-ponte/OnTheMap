//
//  FetchStudentError.swift
//  OnTheMap
//
//  Created by João Ponte on 30/06/2023.
//

import UIKit

enum FetchStudentError: Error {
    case dataCorrupted(debugDescription: String)
    case otherError

    var errorMessage: String {
        switch self {
        case .dataCorrupted:
            return "No internet connection. Please check your network settings and try again."
        case .otherError:
            return "An unexpected error occurred while fetching students. Please try again later."
        }
    }
}

