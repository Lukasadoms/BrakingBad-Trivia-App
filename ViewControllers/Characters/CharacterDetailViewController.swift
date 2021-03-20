//
//  CharacterDetailViewController.swift
//  Project1
//
//  Created by Lukas Adomavicius on 2/27/21.
//

import UIKit

class CharacterDetailViewController: ParentViewController {
    
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterDateOfBirthLabel: UILabel!
    @IBOutlet weak var quoteTableView: UITableView!
    
    var quotes: [QuoteResponse] = []
    var selectedCharacter: CharacterResponse?
    var selectedCharacterName: String?
    var apiManager = APIManager()
    var quotesManager = QuotesManager()
    var group = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
        createSpinnerView()
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
        quoteCell.likedButtonLabel.isHidden = true
        quoteCell.configureQuoteCell(quoteTitle: quotes[indexPath.row].quoteText)
        
        return quoteCell
    }
}

// MARK: - UITableViewDelegate Methods

extension CharacterDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: false)
        let selectedQuote = quotes[indexPath.row]
        
        QuotesManager.quotesAction(quote: selectedQuote)
        quoteTableView.reloadData()
    }
}

// MARK: - API Calls

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
                    self?.showAlert(message: error.errorDescription)
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
                    self?.showAlert(message: error.errorDescription)
                    self?.group.leave()
                }
            })
        }
    }
}

// MARK: - Helpers

extension CharacterDetailViewController {
    func updateUI() {
        let cellNib = UINib(nibName: "QuoteCell", bundle: nil)
        quoteTableView.register(cellNib, forCellReuseIdentifier: "QuoteCell")
        quoteTableView.dataSource = self
        quoteTableView.delegate = self
        quoteTableView.reloadData()
        if let selectedCharacter = selectedCharacter {
            characterNameLabel.text = "Name: \(selectedCharacter.name)"
            characterDateOfBirthLabel.text = "DOB: \(selectedCharacter.birthday)"
        }
        removeSpinnerView()
    }
}
