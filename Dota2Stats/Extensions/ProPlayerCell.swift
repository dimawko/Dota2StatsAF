//
//  ProPlayeCellTableViewCell.swift
//  Dota2Stats
//
//  Created by Dinmukhammed Sagyntkan on 09.04.2022.
//

import UIKit

class ProPlayerCell: UITableViewCell {

    @IBOutlet var avatarImageView: UIImageView!
    @IBOutlet var playerNameLabel: UILabel!
    @IBOutlet var playerTeamLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        avatarImageView.layer.borderWidth = 3
        avatarImageView.layer.borderColor = UIColor(red: 0.56, green: 0.27, blue: 0.68, alpha: 1.00).cgColor
    }
}
