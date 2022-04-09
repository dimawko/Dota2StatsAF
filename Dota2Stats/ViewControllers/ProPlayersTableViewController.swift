//
//  PlayerRanksTableViewController.swift
//  Dota2Stats
//
//  Created by Dinmukhammed Sagyntkan on 08.04.2022.
//

import UIKit

class ProPlayersTableViewController: UITableViewController {
    
    var proPlayers: [ProPlayer] = []
    var proPlayersLimited: [ProPlayer] {
        Array(proPlayers.prefix(20))
    }
    var avatarImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 100

        fetchData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        proPlayersLimited.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "proPlayerCell", for: indexPath)
        let proPlayer = proPlayersLimited[indexPath.row]
        var content = cell.defaultContentConfiguration()
        fetchImage(proPlayer)
        content.text = proPlayer.personaname
        content.textProperties.font = .boldSystemFont(ofSize: 20)
        content.secondaryText = proPlayer.team_name
        content.imageProperties.cornerRadius = tableView.rowHeight / 2
        content.image = avatarImage
        cell.contentConfiguration = content
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let proPlayer = proPlayersLimited[indexPath.row]
        performSegue(withIdentifier: "showProPlayerInfo", sender: proPlayer)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let proPlayerInfoVC = segue.destination as? ProPlayerInfoViewController else { return }
        proPlayerInfoVC.proPlayer = sender as? ProPlayer
    }
    
    func fetchData() {
        NetworkManager.shared.fetchProPlayers { proPlayers in
            self.proPlayers = proPlayers
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func fetchImage(_ proPlayer: ProPlayer) {
        NetworkManager.shared.fetchImage(with: proPlayer.avatarfull) { image in
            self.avatarImage = image
        }
    }
}

