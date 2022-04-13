//
//  PlayerRanksTableViewController.swift
//  Dota2Stats
//
//  Created by Dinmukhammed Sagyntkan on 08.04.2022.
//

import UIKit

class PlayersViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet var loadingLabel: UILabel!
    @IBOutlet var loadingView: UIView!
    
    //MARK: - Private Properties
    private var players: [Player] = []
    private var filteredPlayers: [Player]!
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingSpinner.startAnimating()
        
        getData()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        
        searchBar.delegate = self
        filteredPlayers = players
        
    }
}
// MARK: - TableView Delegate, DataSource
extension PlayersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredPlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "playerCell",
                for: indexPath
            ) as? PlayerCell
        else {
            return UITableViewCell()
        }
        
        let proPlayer = filteredPlayers[indexPath.row]
        
        cell.playerNameLabel.text = proPlayer.personaname
        cell.playerTeamLabel.text = proPlayer.teamName
        NetworkManager.shared.fetchAvatarImages(from: proPlayer.avatarfull ?? "") { result in
            switch result {
            case .success(let imageData):
                cell.avatarImageView.image = UIImage(data: imageData)
            case .failure(let error):
                print(error)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        searchBar.endEditing(true)
        let proPlayer = filteredPlayers[indexPath.row]
        performSegue(withIdentifier: "showPlayerDetails", sender: proPlayer)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
//MARK: - Navigation
extension PlayersViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let proPlayerInfoVC = segue.destination as? PlayerDetailsViewController else { return }
        proPlayerInfoVC.player = sender as? Player
        
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        guard let cell = tableView.cellForRow(at: indexPath) as? PlayerCell else { return }
        proPlayerInfoVC.playerAvatar = cell.avatarImageView.image
    }
}

//MARK: - Networking
extension PlayersViewController {
    
    private func getData() {
        NetworkManager.shared.fetch(dataType: [Player].self, from: Link.proPlayers.rawValue) { result in
            switch result {
            case .success(let players):
                guard let players = players else { return }
                self.players = players
                self.filteredPlayers = self.players
            case .failure(let error):
                print(error)
            }
            self.removeLoadingScreen()
            self.tableView.reloadData()
        }
    }
}

//MARK: - Search bar delegate
extension PlayersViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var filteredPlayersList: [Player] = []
        
        if searchText.isEmpty {
            filteredPlayers = players
            searchBar.perform(
                #selector(self.resignFirstResponder),
                with: nil,
                afterDelay: 0.1
            )
        } else {
            filteredPlayers.forEach { player in
                if player.personaname!.lowercased().contains(searchText.lowercased()) {
                    filteredPlayersList.append(player)
                    filteredPlayers = filteredPlayersList
                }
            }
        }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
}
//MARK: - Loading Screen
extension PlayersViewController {
    
    private func removeLoadingScreen() {
        loadingSpinner.stopAnimating()
        loadingView.isHidden = true
        loadingSpinner.isHidden = true
        loadingLabel.isHidden = true
    }
}
