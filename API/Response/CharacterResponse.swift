//
//  CharacterResponse.swift
//  Project1
//
//  Created by Lukas Adomavicius on 2/28/21.
//

import Foundation

struct CharacterResponse: Decodable {
    var characterID: Int
    var name: String
    var status: String
    var appearance: [Int]
    var birthday: String
    
    enum CodingKeys: String, CodingKey {
        case characterID = "char_id"
        case name, status, appearance, birthday
    }
}
