//
//  CharactersViewController.swift
//  Project1
//
//  Created by Lukas Adomavicius on 3/1/21.
//

import UIKit

class CharactersViewController: ParentViewController {
    
    @IBOutlet weak var characterTableView: UITableView!
    var characters: [CharacterResponse] = []
    var unfilteredCharacters: [CharacterResponse] = []
    var apiManager = APIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSpinnerView()
        getCharacters()
    }
    
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        let charactersFilterViewController = CharactersFilterViewController()
        charactersFilterViewController.characters = characters
        charactersFilterViewController.delegate = self
        show(charactersFilterViewController, sender: nil)
    }
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        characters = unfilteredCharacters
        characterTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource Methods

extension CharactersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenericCell", for: indexPath)
        guard let characterCell = cell as? GenericCell else { return cell }
        
        characterCell.configureCell(cellTitle: characters[indexPath.row].name)
        return characterCell
    }
}

// MARK: - UITableViewDelegate Methods

extension CharactersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCharacter = characters[indexPath.row]
        let characterDetailViewController = CharacterDetailViewController()
        characterDetailViewController.selectedCharacterName = selectedCharacter.name
        show(characterDetailViewController, sender: nil)
    }
}

// MARK: - API Calls

extension CharactersViewController {
    func getCharacters() {
        apiManager.getCharacters({ [weak self] result in
            switch result {
            case .success(let characters):
                DispatchQueue.main.async {
                    self?.characters = characters
                    self?.unfilteredCharacters = characters
                    self?.updateUI()
                }
            case .failure(let error):
                self?.showAlert(message: error.errorDescription)
            }
        })
    }
}

// MARK: - CharactersFilterViewControllerDelegate methods

extension CharactersViewController: CharactersFilterViewControllerDelegate {
    func charactersFilterApplied(filteredCharacters: [CharacterResponse]) {
        characters = filteredCharacters
        characterTableView.reloadData()
    }
}

// MARK: - Helpers

extension CharactersViewController {
    func updateUI() {
        let cellNib = UINib(nibName: "GenericCell", bundle: nil)
        characterTableView.register(cellNib, forCellReuseIdentifier: "GenericCell")
        characterTableView.dataSource = self
        characterTableView.delegate = self
        characterTableView.reloadData()
        removeSpinnerView()
    }
}
