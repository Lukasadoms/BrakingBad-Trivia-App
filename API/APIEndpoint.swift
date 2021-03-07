//
//  APIendpoints.swift
//  Project1
//
//  Created by Lukas Adomavicius on 2/27/21.
//

import Foundation

enum APIEndpoint {
    case episodes
    case episodeInfo(id: Int)
    case charachters
    case characterInfo(name: String)
    case characterQuotes(name: String)

    var url: URL? {
        switch self {
        case .episodes:
            let queryItem = URLQueryItem(name: SeriesNameQueryKey, value: SeriesName)
            return makeURL(endpoint: "api/episodes", queryItems: [queryItem])
        case .episodeInfo(let id):
            return makeURL(endpoint: "api/episodes/\(id)")
        case .charachters:
            let queryItem = URLQueryItem(name: CategoryNameQueryKey, value: SeriesName)
            return makeURL(endpoint: "api/characters", queryItems: [queryItem])
        case .characterInfo(let name):
            let queryItem = URLQueryItem(name: CharacterNameQueryKey, value: name)
            return makeURL(endpoint: "api/characters", queryItems: [queryItem])
        case .characterQuotes(let name):
            let queryItem = URLQueryItem(name: AuthorNameQueryKey, value: name)
            return makeURL(endpoint: "api/quote", queryItems: [queryItem])
        }
    }
}

// MARK: - Helpers

private extension APIEndpoint {
    
    var SeriesNameQueryKey: String {
        "series"
    }
    
    var CategoryNameQueryKey: String {
        "category"
    }

    var AuthorNameQueryKey: String {
        "author"
    }
    
    var CharacterNameQueryKey: String {
        "name"
    }
    
    var SeriesName: String {
        "Breaking+Bad"
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
