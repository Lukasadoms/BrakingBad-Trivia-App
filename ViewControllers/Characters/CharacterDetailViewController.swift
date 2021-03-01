//
//  CharacterDetailViewController.swift
//  Project1
//
//  Created by Lukas Adomavicius on 2/27/21.
//

import UIKit

class CharacterDetailViewController: UIViewController {
    
    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterDateOfBirthLabel: UILabel!
    @IBOutlet weak var quoteTableView: UITableView!
    var quotes: [QuoteResponse] = []
    var selectedCharacter: CharacterResponse?

    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "QuoteCell", bundle: nil)
        quoteTableView.register(cellNib, forCellReuseIdentifier: "QuoteCell")
        quoteTableView.dataSource = self
        guard let selectedCharacter = selectedCharacter else { return }
        characterNameLabel.text = "Name: \(selectedCharacter.name)"
        characterDateOfBirthLabel.text = "DOB: \(selectedCharacter.birthday)"
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
