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
        avatarImageView.layer.borderColor = UIColor.red.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
