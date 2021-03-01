//
//  EpisodesDetailViewController.swift
//  Project1
//
//  Created by Lukas Adomavicius on 2/27/21.
//

import UIKit

final class EpisodesDetailViewController: UIViewController {
    
    @IBOutlet weak var episodeTitleLabel: UILabel!
    @IBOutlet weak var seasonLabel: UILabel!
    @IBOutlet weak var episodeLabel: UILabel!
    @IBOutlet weak var airDateLabel: UILabel!
    @IBOutlet weak var characterTableView: UITableView!
    
    var selectedEpisode: EpisodeResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "CharacterCell", bundle: nil)
        characterTableView.register(cellNib, forCellReuseIdentifier: "CharacterCell")
        characterTableView.dataSource = self
        configureView()
    }
    
    func configureView() {
        if let selectedEpisode = selectedEpisode {
            episodeTitleLabel.text = "Episode: \(selectedEpisode.title)"
            seasonLabel.text = "Season: \(selectedEpisode.season)"
            episodeLabel.text = "Episode: \(selectedEpisode.episode)"
            airDateLabel.text = "Air Date: \(selectedEpisode.airDate)"
        }
    }
}

extension EpisodesDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let selectedEpisode = selectedEpisode {
            return selectedEpisode.characters.count
        } else { return 1 }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath)
        guard
            let characterCell = cell as? CharacterCell,
            let selectedEpisode = selectedEpisode else { return cell }
        
        characterCell.configureCharacterCell(characterTitle: selectedEpisode.characters[indexPath.row])
        return characterCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Characters:"
    }
    
}
