//
//  EpisodesFilterViewController.swift
//  Project1
//
//  Created by Lukas Adomavicius on 2/26/21.
//

import UIKit

class EpisodesFilterViewController: UIViewController {

    @IBOutlet weak var seasonTextField: UITextField!
    @IBOutlet weak var dateFromPicker: UIDatePicker!
    @IBOutlet weak var dateToPicker: UIDatePicker!
    @IBOutlet weak var characterTableView: UITableView!
    var episodes: [EpisodeResponse] = []
    var characters: [CharacterResponse] = [] //Is this the best idea ?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cellNib = UINib(nibName: "CharacterCell", bundle: nil)
        characterTableView.register(cellNib, forCellReuseIdentifier: "CharacterCell")
        characterTableView.dataSource = self
        seasonTextField.delegate = self
        createPickerView()
        dismissPickerView()
    }

    @IBAction func applyButtonPressed(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension EpisodesFilterViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterCell", for: indexPath)
        guard let characterCell = cell as? CharacterCell else { return cell }
        //characterCell[].configureCharacterCell(characterTitle: <#T##String#>)
        return characterCell
    }
}

// MARK: - UIPickerView Methods

extension EpisodesFilterViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let seasons = Int(episodes.last!.season) else { return 0 }
        return seasons
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "Season \(row + 1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.seasonTextField.text = "Season \(row + 1)"
    }

}

// MARK: - SeasonPickerView Methods

extension EpisodesFilterViewController {
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        seasonTextField.inputView = pickerView
    }
    
    func dismissPickerView() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let button = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.action))
        toolBar.setItems([button], animated: true)
        toolBar.isUserInteractionEnabled = true
        seasonTextField.inputAccessoryView = toolBar
    }
    
    @objc func action() {
          view.endEditing(true)
    }
}
