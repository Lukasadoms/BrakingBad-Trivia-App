//
//  CharacterDetailViewController.swift
//  Project1
//
//  Created by Lukas Adomavicius on 2/27/21.
//

import UIKit

class CharacterDetailViewController: ParentViewController, UITableViewDelegate {
    
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterDateOfBirthLabel: UILabel!
    @IBOutlet weak var quoteTableView: UITableView!
    
    var quotes: [QuoteResponse] = []
    var selectedCharacter: CharacterResponse?
    var selectedCharacterName: String?
    var apiManager = APIManager()
    var group = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
        createSpinnerView()
        quoteTableView.delegate = self
        group.enter()
        group.enter()
        getCharacterInfo()
        getCharacterQuotes()
        group.notify(queue: .main, execute: {
            self.updateUI()
        })
    }
}

// MARK: - UITableViewDataSource Methods

extension CharacterDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        quotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
        guard let quoteCell = cell as? QuoteCell else { return cell }
        
        quoteCell.configureQuoteCell(quoteTitle: quotes[indexPath.row].quote)
        return quoteCell
    }
}

extension CharacterDetailViewController {
    func getCharacterInfo() {
        if let selectedCharacterName = selectedCharacterName {
            apiManager.getCharacterInfo(name: selectedCharacterName, { [weak self] result in
                switch result {
                case .success(let character):
                    DispatchQueue.main.async {
                        self?.selectedCharacter = character
                        self?.group.leave()
                    }
                case .failure(let error):
                    print(error)
                    self?.group.leave()
                }
            })
        }
    }
    
    func getCharacterQuotes() {
        if let selectedCharacterName = selectedCharacterName {
            apiManager.getCharacterQuotes(name: selectedCharacterName, { [weak self] result in
                switch result {
                case .success(let quotes):
                    DispatchQueue.main.async {
                        self?.quotes = quotes
                        self?.group.leave()
                    }
                case .failure(let error):
                    print(error)
                    self?.group.leave()
                }
            })
        }
    }
}

extension CharacterDetailViewController {
    func updateUI() {
        let cellNib = UINib(nibName: "QuoteCell", bundle: nil)
        quoteTableView.register(cellNib, forCellReuseIdentifier: "QuoteCell")
        quoteTableView.dataSource = self
        quoteTableView.reloadData()
        guard let selectedCharacter = selectedCharacter else { return }
        characterNameLabel.text = "Name: \(selectedCharacter.name)"
        characterDateOfBirthLabel.text = "DOB: \(selectedCharacter.birthday)"
        removeSpinnerView()
    }
}
