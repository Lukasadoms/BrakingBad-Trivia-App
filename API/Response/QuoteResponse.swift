//
//  QuoteResponse.swift
//  Project1
//
//  Created by Lukas Adomavicius on 3/1/21.
//

import Foundation

struct QuoteResponse: Decodable {
    var quoteID: Int
    var quote: String
    var author: String
    
    enum CodingKeys: String, CodingKey {
        case quoteID = "quote_id"
        case quote, author
    }
}
