//
//  EpisodeCell.swift
//  Project1
//
//  Created by Lukas Adomavicius on 2/26/21.
//

import UIKit

final class GenericCell: UITableViewCell {
    
    @IBOutlet weak var cellTitleLabel: UILabel!
    
    func configureCell(cellTitle: String) {
        cellTitleLabel.text = cellTitle
    }
}
