//
//  CharacterCell.swift
//  Project1
//
//  Created by Lukas Adomavicius on 2/27/21.
//

import UIKit

class CharacterCell: UITableViewCell {

    @IBOutlet weak var characterLabel: UILabel!
    
    func configureCharacterCell(characterTitle: String) {
        characterLabel.text = characterTitle
    }
    
}
