//
//  EpisodesVIewController.swift
//  Project1
//
//  Created by Lukas Adomavicius on 2/25/21.
//

import UIKit

final class EpisodesViewController: UIViewController {

    @IBOutlet weak var episodesTableView: UITableView!
    
    var episodes: [EpisodeResponse] = []
    var apiManager = APIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        let cellNib = UINib(nibName: "EpisodeCell", bundle: nil)
        episodesTableView.register(cellNib, forCellReuseIdentifier: "EpisodeCell")
        episodesTableView.dataSource = self
        episodesTableView.delegate = self
    }
    
    @IBAction func filterButtonPressed(_ sender: Any) {
        let filterViewController = EpisodesFilterViewController()
        filterViewController.episodes = episodes
        show(filterViewController, sender: nil)
    }
}

// MARK: - UITableViewDataSource Methods

extension EpisodesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var seasonEpisodes: [EpisodeResponse] = []
        for episode in episodes {
            if Int(episode.season.trimmingCharacters(in: .whitespacesAndNewlines)) == section + 1 {
                seasonEpisodes.append(episode)
            }
        }
        return seasonEpisodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeCell", for: indexPath)
        guard let episodeCell = cell as? EpisodeCell else { return cell }
        
        var seasonEpisodes: [EpisodeResponse] = []
        for episode in episodes {
            if Int(episode.season.trimmingCharacters(in: .whitespacesAndNewlines)) == indexPath.section + 1 {
                seasonEpisodes.append(episode)
            }
        }

        episodeCell.configureEpisodeCell(episodeTitle: seasonEpisodes[indexPath.row].title)
        return episodeCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let seasons = Int(episodes.last!.season) else { return 0}
        return seasons
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Season \(section + 1)"
    }
}

// MARK: - UITableViewDelegate Methods

extension EpisodesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedEpisode = episodes.filter {
            Int($0.season.trimmingCharacters(in: .whitespacesAndNewlines)) == indexPath.section + 1 &&
            Int($0.episode) == indexPath.row + 1 } // rethink
        
        let episodeDetailViewController = EpisodesDetailViewController()
        episodeDetailViewController.selectedEpisode = selectedEpisode.first
        show(episodeDetailViewController, sender: nil)
    }
}
