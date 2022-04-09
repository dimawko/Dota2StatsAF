//
//  ProPlayerInfoViewController.swift
//  Dota2Stats
//
//  Created by Dinmukhammed Sagyntkan on 09.04.2022.
//

import UIKit

class PlayerDetailsViewController: UIViewController {
    
    var proPlayer: ProPlayer!
    var playerAvatar: UIImage!
    var proPlayerInfo: ProPlayerInfo!
    
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerTeamLabel: UILabel!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerNameLabel.text = proPlayer.personaname
        playerTeamLabel.text = proPlayer.team_name
        avatarImageView.image = playerAvatar
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.layer.borderWidth = 10
        avatarImageView.layer.borderColor = UIColor.black.cgColor
        
        fetchPlayerDetails()
    }
    
    func fetchPlayerDetails() {
        NetworkManager.shared.downloadPlayerDetails(with: proPlayer.account_id) { proPlayerInfo in
            self.proPlayerInfo = proPlayerInfo
            DispatchQueue.main.async {
                self.testLabel.text = String(proPlayerInfo.solo_competitive_rank ?? 0)
            }
        }
    }
}
