//
//  APIErrors.swift
//  Project1
//
//  Created by Lukas Adomavicius on 2/27/21.
//

import Foundation

enum APIError: Error {
    case failedRequest
    case unexpectedDataFormat
    case failedResponse
    case failedURLCreation
    
    var errorDescription: String {
        switch self {
        case .failedRequest:
            return "Missing required values, or passwords don`t match!"
        case .unexpectedDataFormat:
            return "This username is already taken!"
        case .failedResponse:
            return "Password is incorrect!"
        case .failedURLCreation:
            return "Account with this username is not found!"
        }
    }
}
