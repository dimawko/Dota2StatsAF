//
//  ProPlayerInfoViewController.swift
//  Dota2Stats
//
//  Created by Dinmukhammed Sagyntkan on 09.04.2022.
//

import UIKit

class ProPlayerInfoViewController: UIViewController {
    
    var proPlayer: ProPlayer!
    
    @IBOutlet var proPlayerNameLabel: UILabel!
    @IBOutlet var proPlayerTeamLabel: UILabel!
    @IBOutlet var proPlayerAvatar: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        proPlayerNameLabel.text = proPlayer.personaname
        proPlayerTeamLabel.text = proPlayer.team_name
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
