//
//  LeaguesTableViewCell.swift
//  SportsApp
//
//  Created by Ayman Omara on 21/04/2021.
//  Copyright © 2021 Menna Elhelaly. All rights reserved.
//

import UIKit

class LeaguesTableViewCell: UITableViewCell {

    @IBOutlet weak var YoutubeOutlet: UIImageView!
    @IBOutlet weak var leageNameOutlet: UILabel!
    @IBOutlet weak var leagueTitleImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

 
    }

}
