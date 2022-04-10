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
    var playerWinAndLoses: PlayerWinsAndLoses!
    
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerTeamLabel: UILabel!
    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var statSquareViews: [UIView]!
    @IBOutlet var statLabels: [UILabel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerNameLabel.text = proPlayer.personaname
        playerTeamLabel.text = proPlayer.team_name
        avatarImageView.image = playerAvatar
        
  
        
        fetchPlayerDetails()
        fetchPlayerWinAndLoses()
        
        statSquareViews.forEach({ view in
            view.layer.shadowOffset = CGSize(width: 10,
                                             height: 10)
            view.layer.shadowRadius = 5
            view.layer.shadowOpacity = 0.3
        })
        
        
    }
    
    override func viewDidLayoutSubviews() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        avatarImageView.layer.borderWidth = 3
        avatarImageView.layer.borderColor = UIColor.white.cgColor
        print(avatarImageView.frame.height, avatarImageView.frame.width)
    }
    
    override func viewWillAppear(_ animated: Bool) {
   
    }
    
    func fetchPlayerDetails() {
        NetworkManager.shared.downloadPlayerDetails(with: proPlayer.account_id) { proPlayerInfo in
            self.proPlayerInfo = proPlayerInfo
            DispatchQueue.main.async {
                
            }
        }
    }
    
    func fetchPlayerWinAndLoses() {
        NetworkManager.shared.downloadPlayerWinAndLoses(with: proPlayer.account_id) { playerWinAndLoses in
            self.playerWinAndLoses = playerWinAndLoses
            DispatchQueue.main.async {
                self.statLabels.forEach { label in
                    switch label.tag {
                    case 0:
                        label.text = String(playerWinAndLoses.win ?? 0)
                    default:
                        label.text = String(playerWinAndLoses.lose ?? 0)
                    }
                }
            }
        }
    }
}
