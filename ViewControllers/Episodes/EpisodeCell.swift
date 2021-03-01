//
//  EpisodeCell.swift
//  Project1
//
//  Created by Lukas Adomavicius on 2/26/21.
//

import UIKit

final class EpisodeCell: UITableViewCell {
    
    @IBOutlet weak var episodeTitleLabel: UILabel!
    
    func configureEpisodeCell(episodeTitle: String) {
        episodeTitleLabel.text = episodeTitle
    }
}
