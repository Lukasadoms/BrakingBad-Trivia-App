//
//  HomeViewController.swift
//  Project1
//
//  Created by Lukas Adomavicius on 2/24/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    var apiManager = APIManager()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    @IBAction func episodesButtonTapped(_ sender: UIButton) {
        apiManager.getEpisodes({ [weak self] result in
            switch result {
            case .success(let episodes):
                print(episodes)
                DispatchQueue.main.async {
                    let episodesViewController = EpisodesViewController()
                    episodesViewController.episodes = episodes
                    self?.show(episodesViewController, sender: nil)
                }
            case .failure(_):
                print("error")
            }
        })
    }
    
    @IBAction func charactersButtonTapped(_ sender: UIButton) {
        apiManager.getCharacters({ [weak self] result in
            switch result {
            case .success(let characters):
                DispatchQueue.main.async {
                    let charactersViewController = CharactersViewController()
                    charactersViewController.characters = characters
                    self?.show(charactersViewController, sender: nil)
                }
            case .failure(_):
                print("error")
            }
        })
    }
    
    @IBAction func quotesButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        AccountManager.loggedInAccount = nil
        dismiss(animated: true)
    }
    
    private func configureView() {
        if let loggedInAccount = AccountManager.loggedInAccount {
            titleLabel.text = "Breaking Bad fan: " + loggedInAccount.username
        }
    }
}
