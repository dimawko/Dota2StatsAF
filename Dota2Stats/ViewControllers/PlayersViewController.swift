//
//  PlayerRanksTableViewController.swift
//  Dota2Stats
//
//  Created by Dinmukhammed Sagyntkan on 08.04.2022.
//

import UIKit

class PlayersViewController: UIViewController {
    
    //MARK: - IBOutlets
//    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet var loadingLabel: UILabel!
    @IBOutlet var loadingView: UIView!
    
    //MARK: - Private Properties
    private var players: [Player] = []
    private var filteredPlayers: [Player]!
    
    private lazy var searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search player by nickname"
        searchController.searchBar.showsCancelButton = false
        return searchController
    }()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingSpinner.startAnimating()
        
        getData()
        
        navigationItem.hidesSearchBarWhenScrolling = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        
        setupNavigationBar()
        filteredPlayers = players
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        searchController.searchBar.text = ""
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
        let proPlayer = filteredPlayers[indexPath.row]
        performSegue(withIdentifier: "showPlayerDetails", sender: proPlayer)
        tableView.deselectRow(at: indexPath, animated: true)
        searchController.searchBar.endEditing(true)
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

//MARK: - Loading Screen
extension PlayersViewController {
    
    private func removeLoadingScreen() {
        loadingSpinner.stopAnimating()
        loadingView.isHidden = true
        loadingSpinner.isHidden = true
        loadingLabel.isHidden = true
    }
}

//MARK: - Navigation Bar
extension PlayersViewController {
    
    private func setupNavigationBar() {
         navigationItem.searchController = searchController
     }
}
//MARK: - Search Controller Delegate
extension PlayersViewController: UISearchResultsUpdating, UISearchControllerDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredPlayers = []
        guard let searchText = searchController.searchBar.text else { return }
        if searchText.isEmpty {
            filteredPlayers = players
        } else {
            players.forEach { player in
                if player.personaname!.lowercased().contains(searchText.lowercased()) {
                    filteredPlayers.append(player)
                }
            }
        }
        tableView.reloadData()
    }
}
