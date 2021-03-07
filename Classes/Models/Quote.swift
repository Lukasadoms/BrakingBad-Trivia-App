//
//  LikedQuotes.swift
//  Project1
//
//  Created by Lukas Adomavicius on 3/7/21.
//

import Foundation

struct Quote: Codable {
    var quote: QuoteResponse
    var likedByUsers: [Account] = []
}
