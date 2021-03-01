//
//  CharactersViewController.swift
//  Project1
//
//  Created by Lukas Adomavicius on 3/1/21.
//

import UIKit

class CharactersViewController: UIViewController {
    
    
    @IBOutlet weak var characterTableView: UITableView!
    var characters: [CharacterResponse] = []
    var apiManager = APIManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "CharacterCell", bundle: nil)
        characterTableView.register(cellNib, forCellReuseIdentifier: "CharacterCell")
        characterTableView.dataSource = self
        characterTableView.delegate = self
    }
    
    @IBAction func filterButtonTapped(_ sender: UIButton) {
    }
}

// MARK: - UITableViewDataSource Methods

extension CharactersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath)
        guard let characterCell = cell as? CharacterCell else { return cell }
        
        characterCell.configureCharacterCell(characterTitle: characters[indexPath.row].name)
        return characterCell
    }
}

// MARK: - UITableViewDelegate Methods

extension CharactersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCharacter = characters[indexPath.row]
        
        apiManager.getCharacterQuotes(name: selectedCharacter.name, { [weak self] result in
            switch result {
            case .success(let quotes):
                DispatchQueue.main.async {
                    let characterDetailViewController = CharacterDetailViewController()
                    characterDetailViewController.quotes = quotes
                    characterDetailViewController.selectedCharacter = selectedCharacter
                    self?.show(characterDetailViewController, sender: nil)
                }
            case .failure(let error):
                print(error)
            }
        })
    }
}
