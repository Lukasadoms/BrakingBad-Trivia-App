//
//  CharactersFilterViewController.swift
//  Project1
//
//  Created by Lukas Adomavicius on 3/7/21.
//

import UIKit

protocol CharactersFilterViewControllerDelegate: AnyObject {
    func charactersFilterApplied(filteredCharacters: [CharacterResponse])
}

class CharactersFilterViewController: ParentViewController {
    var apiManager = APIManager()
    var characters: [CharacterResponse] = []
    var episodes: [EpisodeResponse] = []
    var seasons = [1, 2, 3, 4, 5]
    var selectedCharacterStatus: String = "Deceased"
    var selectedSeasons: [Int]?
    weak var delegate: CharactersFilterViewControllerDelegate?
    
    @IBOutlet weak var seasonTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "GenericCell", bundle: nil)
        seasonTableView.register(cellNib, forCellReuseIdentifier: "GenericCell")
        seasonTableView.dataSource = self
        seasonTableView.delegate = self
        seasonTableView.reloadData()
    }
    
    @IBAction func statusChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            selectedCharacterStatus = "Deceased"
        case 1:
            selectedCharacterStatus = "Alive"
        default:
            selectedCharacterStatus = "Deceased"
        }
    }
    @IBAction func applyButtonPressed(_ sender: UIButton) {
        filterCharacters()
        delegate?.charactersFilterApplied(filteredCharacters: characters)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource Methods

extension CharactersFilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        seasons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenericCell", for: indexPath)
        guard let seasonCell = cell as? GenericCell else { return cell }
        
        let selectedIndexPaths = tableView.indexPathsForSelectedRows
        let rowIsSelected = selectedIndexPaths != nil && selectedIndexPaths!.contains(indexPath)
        
        seasonCell.selectionStyle = .none
        seasonCell.accessoryType = rowIsSelected ? .checkmark : .none
        seasonCell.configureCell(cellTitle: "Season" + "\(indexPath.row + 1)")
        return seasonCell
    }
}

// MARK: - UITableViewDelegate Methods

extension CharactersFilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        }
        
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
}

// MARK: - API Calls

extension CharactersFilterViewController {
    func getEpisodes() {
        apiManager.getEpisodes({ [weak self] result in
            switch result {
            case .success(let episodes):
                print(episodes)
                DispatchQueue.main.async {
                    self?.episodes = episodes
                    self?.removeSpinnerView()
                }
            case .failure(_):
                print("error")
            }
        })
    }
}

// MARK: - Helpers

extension CharactersFilterViewController {
    func getSelectedSeasons() {
        guard let selectedRows = seasonTableView.indexPathsForSelectedRows else { return }
        selectedSeasons = selectedRows.map { seasons[$0.row] }
    }
    
    func filterCharacters() {
        getSelectedSeasons()
        if let selectedSeasons = selectedSeasons {
            characters = characters.filter { $0.appearance.contains(array: selectedSeasons)
            }
        }
        characters = characters.filter { $0.status == selectedCharacterStatus || $0.status == "Presumed dead" }
    }
}

