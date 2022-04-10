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
    
    //MARK: - Private Properties
    private var players: [Player] = []
    private var filteredPlayers: [Player]!
    
    private let loadingView = UIView()
    private let spinner = UIActivityIndicatorView()
    private let loadingLabel = UILabel()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLoadingScreen()
        getData()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        filteredPlayers = players
    }
}
// MARK: - TableView data source
extension PlayersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredPlayers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as? PlayerCell else { return UITableViewCell() }
        let proPlayer = filteredPlayers[indexPath.row]
        cell.playerNameLabel.text = proPlayer.personaname
        cell.playerTeamLabel.text = proPlayer.team_name
        NetworkManager.shared.fetchAvatarImages(with: proPlayer) { data in
            let image = self.getImage(from: data)
            DispatchQueue.main.async {
                cell.avatarImageView.image = image
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let proPlayer = filteredPlayers[indexPath.row]
        performSegue(withIdentifier: "showPlayerDetails", sender: proPlayer)
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
        NetworkManager.shared.fetchPlayers { proPlayers in
            self.players = proPlayers
            self.filteredPlayers = self.players
            DispatchQueue.main.async {
                self.removeLoadingScreen()
                self.tableView.reloadData()
            }
        }
    }
    
    private func getImage(from data: Data?) -> UIImage? {
        guard let data = data else { return UIImage(systemName: "picture") }
        return UIImage(data: data)
    }
}

//MARK: - Search bar
extension PlayersViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var filteredPlayersList: [Player] = []
        
        if searchText.isEmpty {
            filteredPlayers = players
        } else {
            filteredPlayers.forEach { player in
                if player.personaname.lowercased().contains(searchText.lowercased()) {
                    filteredPlayersList.append(player)
                    filteredPlayers = filteredPlayersList
                }
            }
        }
        tableView.reloadData()
    }
}
//MARK: - Loading Screen
extension PlayersViewController {
    
    private func setLoadingScreen() {
        let width: CGFloat = 120
        let height: CGFloat = 30
        let x = (view.frame.width / 2) - (width / 2)
        let y = (view.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
        loadingView.frame = CGRect(x: x, y: y, width: width, height: height)
        
        loadingLabel.textColor = .gray
        loadingLabel.textAlignment = .center
        loadingLabel.text = "Loading..."
        loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)
        
        spinner.style = .medium
        spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        spinner.startAnimating()
        
        loadingView.addSubview(loadingLabel)
        loadingView.addSubview(spinner)
       
        tableView.addSubview(loadingView)
    }
    
    private func removeLoadingScreen() {
        spinner.stopAnimating()
        loadingView.isHidden = true
        spinner.isHidden = true
        loadingLabel.isHidden = true
    }
}


