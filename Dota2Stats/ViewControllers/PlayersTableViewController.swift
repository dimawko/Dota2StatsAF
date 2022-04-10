//
//  PlayerRanksTableViewController.swift
//  Dota2Stats
//
//  Created by Dinmukhammed Sagyntkan on 08.04.2022.
//

import UIKit

class PlayersTableViewController: UITableViewController {
    
    var players: [Player] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData()
    }
}
// MARK: - Table view data source
extension PlayersTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        players.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "proPlayerCell", for: indexPath) as? ProPlayerCell else { return UITableViewCell() }
        let proPlayer = players[indexPath.row]
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let proPlayer = players[indexPath.row]
        performSegue(withIdentifier: "showProPlayerInfo", sender: proPlayer)
    }
}
//MARK: - Navigation
extension PlayersTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let proPlayerInfoVC = segue.destination as? PlayerDetailsViewController else { return }
        proPlayerInfoVC.player = sender as? Player
        
        guard let indexPath = tableView.indexPathForSelectedRow else { return }
        let cell = tableView.cellForRow(at: indexPath) as? ProPlayerCell
        proPlayerInfoVC.playerAvatar = cell?.avatarImageView.image
    }
}

//MARK: - Networking
extension PlayersTableViewController {
    private func getData() {
        NetworkManager.shared.fetchPlayers { proPlayers in
            self.players = proPlayers
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func getImage(from data: Data?) -> UIImage? {
        guard let data = data else { return UIImage(systemName: "picture") }
        return UIImage(data: data)
    }
}


