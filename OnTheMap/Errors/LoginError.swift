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
            return "The credentials were incorrect, please check your email or/and your password."
        case .keyNotFound:
            return "The credentials were incorrect, please check your email or/and your password."
        case .networkError:
            return "The Internet connection is offline, please try again later."
        case .otherError:
            return "An unexpected error occurred. Please try again later."
        }
    }
}
