//
//  EpisodesFilterViewController.swift
//  Project1
//
//  Created by Lukas Adomavicius on 2/26/21.
//

import UIKit

protocol EpisodesFilterViewControllerDelegate: AnyObject {
    func episodesFilterApplied(filteredEpisodes: [EpisodeResponse])
}

class EpisodesFilterViewController: ParentViewController {

    @IBOutlet weak var seasonTextField: UITextField!
    @IBOutlet weak var dateFromTextField: UITextField!
    @IBOutlet weak var dateToTextField: UITextField!
    @IBOutlet weak var characterTableView: UITableView!
    
    var episodes: [EpisodeResponse] = []
    var characters: [CharacterResponse] = []
    let datePicker = UIDatePicker()
    let apiManager = APIManager()
    
    var selectedCharacters: [String]?
    var selectedSeason: String?
    var selectedFromDate: String?
    var selectedToDate: String?
    
    weak var delegate: EpisodesFilterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createSpinnerView()
        getCharacters()
    }

    @IBAction func applyButtonPressed(_ sender: UIButton) {
        filterEpisodes()
        delegate?.episodesFilterApplied(filteredEpisodes: episodes)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDataSource Methods

extension EpisodesFilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GenericCell", for: indexPath)
        guard let characterCell = cell as? GenericCell else { return cell }
        
        let selectedIndexPaths = tableView.indexPathsForSelectedRows
        let rowIsSelected = selectedIndexPaths != nil && selectedIndexPaths!.contains(indexPath)
        
        characterCell.selectionStyle = .none
        characterCell.accessoryType = rowIsSelected ? .checkmark : .none
        characterCell.configureCell(cellTitle: characters[indexPath.row].name)
        return characterCell
    }
}

// MARK: - UITableViewDelegate Methods

extension EpisodesFilterViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        }
        
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
    }
}

// MARK: - seasonPickerView Methods

extension EpisodesFilterViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let seasons = Int(episodes.last?.season ?? "0") else { return 0 }
        return seasons
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "Season \(row + 1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSeason = "\(row + 1)"
        seasonTextField.text = "Season \(selectedSeason!)"
    }

}

// MARK: - PickerView Methods

extension EpisodesFilterViewController {
    func createSeasonPickerView() {
        let seasonPickerView = UIPickerView()
        seasonPickerView.delegate = self
        seasonTextField.inputView = seasonPickerView
    }
    
    func createDatePickerView() {
        dateToTextField.inputView = datePicker
        dateFromTextField.inputView = datePicker
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.donePressed))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        seasonTextField.inputAccessoryView = toolBar
        dateFromTextField.inputAccessoryView = toolBar
        dateToTextField.inputAccessoryView = toolBar
    }
    
    @objc func donePressed() {
        if dateFromTextField.isFirstResponder {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "MM-dd-yyyy"
            dateFromTextField.text = dateFormatter.string(from: datePicker.date)
            selectedFromDate = dateFromTextField.text
        }
        if dateToTextField.isFirstResponder {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            dateFormatter.dateFormat = "MM-dd-yyyy"
            dateToTextField.text = dateFormatter.string(from: datePicker.date)
            selectedToDate = dateToTextField.text
        }
        view.endEditing(true)
    }
}

// MARK: - Helpers

extension EpisodesFilterViewController {
    func updateUI() {
        let cellNib = UINib(nibName: "GenericCell", bundle: nil)
        characterTableView.register(cellNib, forCellReuseIdentifier: "GenericCell")
        
        characterTableView.dataSource = self
        characterTableView.delegate = self
        characterTableView.reloadData()

        createSeasonPickerView()
        createDatePickerView()
        dismissPickerView()
        
        removeSpinnerView()
    }
    
    func getSelectedCharacters() {
        guard let selectedRows = characterTableView.indexPathsForSelectedRows else { return }
        selectedCharacters = selectedRows.map { characters[$0.row].name }
    }
    
    func filterEpisodes() {
        getSelectedCharacters()
        
        if let selectedSeason = selectedSeason {
            episodes = episodes.filter { $0.season == selectedSeason }
        }
        
        if let selectedToDate = selectedToDate {
            episodes = episodes.filter { $0.airDate.toDate()! < selectedToDate.toDate()! }
        }
        
        if let selectedFromDate = selectedFromDate {
            episodes = episodes.filter { $0.airDate.toDate()! > selectedFromDate.toDate()! }
        }
        
        if let selectedCharacters = selectedCharacters {
            episodes = episodes.filter { $0.characters.contains(array: selectedCharacters)}
        }
    }
}

// MARK: - API Calls

extension EpisodesFilterViewController {
    func getCharacters() {
        apiManager.getCharacters { [weak self] result in
            switch result {
            case .success(let characters):
                DispatchQueue.main.async {
                    self?.characters = characters
                    self?.updateUI()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
