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
    case failedAuthentication
}
