//
//  APImanager.swift
//  Project1
//
//  Created by Lukas Adomavicius on 2/27/21.
//

import Foundation

struct APIManager {
    
    private var session: URLSession {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration)
    }
    
    // MARK: - Get All Episodes
    
    func getEpisodes(_ completion: @escaping (Result<[EpisodeResponse], APIError>) -> Void) {

        guard let url = APIEndpoint.episodes.url
        else {
            completion(.failure(.failedURLCreation))
            return
        }

        session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(.failedRequest))
                return
            }

            guard let episodesResponse = try? JSONDecoder().decode([EpisodeResponse].self, from: data) else {
                completion(.failure(.unexpectedDataFormat))
                return
            }
            completion(.success(episodesResponse))
        }.resume()
    }
    
    // MARK: - Get Episode Info
    
    func getEpisodeInfo(id: Int, _ completion: @escaping (Result<EpisodeResponse, APIError>) -> Void) {
        
        guard let url = APIEndpoint.episodeInfo(id: id).url
        else {
            completion(.failure(.failedURLCreation))
            return
        }

        session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(.failedRequest))
                return
            }

            guard let episodeDataResponse = try? JSONDecoder().decode(EpisodeResponse.self, from: data) else {
                completion(.failure(.unexpectedDataFormat))
                return
            }
            completion(.success(episodeDataResponse))
        }.resume()
    }
    
    // MARK: - Get All Characters
    
    func getCharacters(_ completion: @escaping (Result<[CharacterResponse], APIError>) -> Void) {

        guard let url = APIEndpoint.charachters.url
        else {
            completion(.failure(.failedURLCreation))
            return
        }

        session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(.failedRequest))
                return
            }

            guard let charactersResponse = try? JSONDecoder().decode([CharacterResponse].self, from: data) else {
                completion(.failure(.unexpectedDataFormat))
                return
            }
            completion(.success(charactersResponse))
        }.resume()
    }
    
    // MARK: - Get Character Info
    
    func getCharacterInfo(name: String, _ completion: @escaping (Result<CharacterResponse, APIError>) -> Void) {
        
        guard let url = APIEndpoint.characterInfo(name: name).url
        else {
            completion(.failure(.failedURLCreation))
            return
        }

        session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(.failedRequest))
                return
            }

            guard let characterInfoResponse = try? JSONDecoder().decode([CharacterResponse].self, from: data) else {
                completion(.failure(.unexpectedDataFormat))
                return
            }
            completion(.success(characterInfoResponse.first!))
        }.resume()
    }
    
    // MARK: - Get Character Quotes
    
    func getCharacterQuotes(name: String, _ completion: @escaping (Result<[QuoteResponse], APIError>) -> Void) {
        
        guard let url = APIEndpoint.characterQuotes(name: name).url
        else {
            completion(.failure(.failedURLCreation))
            return
        }

        session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(.failedRequest))
                return
            }

            guard let characterQuoteDataResponse = try? JSONDecoder().decode([QuoteResponse].self, from: data) else {
                completion(.failure(.unexpectedDataFormat))
                return
            }
            completion(.success(characterQuoteDataResponse))
        }.resume()
    }
    
    // MARK: - Get Random Quote
    
    func getRandomQuote(_ completion: @escaping (Result<QuoteResponse, APIError>) -> Void) {
        
        guard let url = APIEndpoint.randomQuote.url
        else {
            completion(.failure(.failedURLCreation))
            return
        }

        session.dataTask(with: url) { data, response, error in
            guard let data = data else {
                completion(.failure(.failedRequest))
                return
            }

            guard let randomQuoteDataResponse = try? JSONDecoder().decode([QuoteResponse].self, from: data) else {
                completion(.failure(.unexpectedDataFormat))
                return
            }
            completion(.success(randomQuoteDataResponse.first!))
        }.resume()
    }
}
