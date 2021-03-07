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
    let apiManager = APIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "GenericCell", bundle: nil)
        characterTableView.register(cellNib, forCellReuseIdentifier: "GenericCell")
        characterTableView.dataSource = self
        characterTableView.delegate = self
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenericCell", for: indexPath)
        guard
            let characterCell = cell as? GenericCell,
            let selectedEpisode = selectedEpisode else { return cell }
        
        characterCell.configureCell(cellTitle: selectedEpisode.characters[indexPath.row])
        return characterCell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Characters:"
    }
    
}

// MARK: - UITableViewDelegate Methods

extension EpisodesDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedEpisode = selectedEpisode {
            let selectedCharacter = selectedEpisode.characters[indexPath.row]
            
            let characterDetailViewController = CharacterDetailViewController()
            characterDetailViewController.selectedCharacterName = selectedCharacter
            show(characterDetailViewController, sender: nil)
            
        }
    }
}
