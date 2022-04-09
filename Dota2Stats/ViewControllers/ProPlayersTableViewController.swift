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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        proPlayersLimited.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "proPlayerCell", for: indexPath) as? ProPlayeCellTableViewCell else { return UITableViewCell() }
        let proPlayer = proPlayersLimited[indexPath.row]
        cell.proPlayerNicknameLabel.text = proPlayer.personaname
        cell.proPlayerTeamLabel.text = proPlayer.team_name
        NetworkManager.shared.downloadImage(with: proPlayer) { data in
            let image = self.image(data: data)
            DispatchQueue.main.async {
                cell.avatarImageView.image = image
            }
        }
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
    
    func image(data: Data?) -> UIImage? {
        guard let data = data else { return UIImage(systemName: "picture") }
        return UIImage(data: data)
    }
}

