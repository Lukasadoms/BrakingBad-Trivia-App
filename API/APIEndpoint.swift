//
//  APIendpoints.swift
//  Project1
//
//  Created by Lukas Adomavicius on 2/27/21.
//

import Foundation

enum APIEndpoint {
    case episodes
    case episodeData(id: Int)
    case charachters
    case characterQuotes(name: String)
    
    var url: URL? {
        switch self {
        case .episodes:
            return makeURL(endpoint: "api/episodes?series=Breaking+Bad")
        case .episodeData(let id):
            return makeURL(endpoint: "api/episodes/\(id)")
        case .charachters:
            return makeURL(endpoint: "api/characters?category=Breaking+Bad")
        case .characterQuotes(let characterName):
            let queryItem = URLQueryItem(name: AuthorNameQueryKey, value: "\(characterName)")
            return makeURL(endpoint: "api/quote", queryItems: [queryItem])
        }
    }
}

// MARK: - Helpers

private extension APIEndpoint {

    var AuthorNameQueryKey: String {
        "author"
    }

    var BaseURL: String {
        "https://www.breakingbadapi.com/"
    }

    func makeURL(endpoint: String, queryItems: [URLQueryItem]? = nil) -> URL? {
        let urlString = BaseURL + endpoint

        guard let queryItems = queryItems else {
            return URL(string: urlString)
        }

        var components = URLComponents(string: urlString)
        components?.queryItems = queryItems
        return components?.url
    }
}
