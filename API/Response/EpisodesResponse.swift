//
//  EpisodesResponse.swift
//  Project1
//
//  Created by Lukas Adomavicius on 2/27/21.
//

import Foundation

struct EpisodeResponse: Decodable {
    
    let episodeID: Int
    let title, season, airDate: String
    let characters: [String]
    let episode, series: String
    
    enum CodingKeys: String, CodingKey {
        case episodeID = "episode_id"
        case title, season
        case airDate = "air_date"
        case characters, episode, series
    }
}
