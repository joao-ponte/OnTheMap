//
//  LoginError.swift
//  OnTheMap
//
//  Created by João Ponte on 23/06/2023.
//

import UIKit

enum LoginError: Error {
    case incorrectCredentials
    case keyNotFound
    case networkError
    case otherError

    var errorMessage: String {
        switch self {
        case .incorrectCredentials:
            return "Incorrect email or password. Please try again."
        case .keyNotFound:
            return "Incorrect email or password. Please try again."
        case .networkError:
            return "Network error occurred. Please check your internet connection and try again."
        case .otherError:
            return "An unexpected error occurred. Please try again later."
        }
    }
}
