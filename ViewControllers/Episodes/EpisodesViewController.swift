//
//  EpisodesVIewController.swift
//  Project1
//
//  Created by Lukas Adomavicius on 2/25/21.
//

import UIKit

class EpisodesViewController: ParentViewController {

    @IBOutlet weak var episodesTableView: UITableView!
    
    var episodes: [EpisodeResponse] = []
    var unfilteredEpisodes: [EpisodeResponse] = []
    var apiManager = APIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSpinnerView()
        getEpisodes()
    }

    @IBAction func filterButtonPressed(_ sender: Any) {
        let filterViewController = EpisodesFilterViewController()
        filterViewController.delegate = self
        filterViewController.episodes = episodes
        show(filterViewController, sender: nil)
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        episodes = unfilteredEpisodes
        episodesTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource Methods

extension EpisodesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var seasonEpisodes: [EpisodeResponse] = []
        for episode in episodes {
            let episodeSeason = Int(episode.season.trimmingCharacters(in: .whitespacesAndNewlines))
            if episodeSeason == section + 1 {
                seasonEpisodes.append(episode)
            }
        }
        return seasonEpisodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenericCell", for: indexPath)
        guard let episodeCell = cell as? GenericCell else { return cell }
        
        var seasonEpisodes: [EpisodeResponse] = []
        for episode in episodes {
            if Int(episode.season.trimmingCharacters(in: .whitespacesAndNewlines)) == indexPath.section + 1 {
                seasonEpisodes.append(episode)
            }
        }
        episodeCell.configureCell(cellTitle: seasonEpisodes[indexPath.row].title)
        return episodeCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard
            let lastEpisode = episodes.last?.season,
            let seasons = Int(lastEpisode) else { return 0}
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
            Int($0.episode) == indexPath.row + 1 }
        
        let episodeDetailViewController = EpisodesDetailViewController()
        episodeDetailViewController.selectedEpisode = selectedEpisode.first
        show(episodeDetailViewController, sender: nil)
    }
}

// MARK: - EpisodesFilterViewControllerDelegate Methods

extension EpisodesViewController: EpisodesFilterViewControllerDelegate {
    func episodesFilterApplied(filteredEpisodes: [EpisodeResponse]) {
        episodes = filteredEpisodes
        episodesTableView.reloadData()
    }
}

// MARK: - Helpers

extension EpisodesViewController {
    private func updateUI() {
        let cellNib = UINib(nibName: "GenericCell", bundle: nil)
        episodesTableView.register(cellNib, forCellReuseIdentifier: "GenericCell")
        episodesTableView.dataSource = self
        episodesTableView.delegate = self
        episodesTableView.reloadData()
        removeSpinnerView()
    }
}

// MARK: - API Calls

extension EpisodesViewController {
    func getEpisodes() {
        apiManager.getEpisodes({ [weak self] result in
            switch result {
            case .success(let episodes):
                DispatchQueue.main.async {
                    self?.episodes = episodes
                    self?.unfilteredEpisodes = episodes
                    self?.updateUI()
                }
            case .failure(let error):
                self?.showAlert(message: error.errorDescription)
            }
        })
    }
}
