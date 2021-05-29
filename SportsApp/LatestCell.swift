//
//  LatestCell.swift
//  SportsApp
//
//  Created by Amin on 20/04/2021.
//

import UIKit

class LatestCell: UITableViewCell {

    @IBOutlet weak var uiTeamOneImage: UIImageView!
    
    @IBOutlet weak var uiTeamTwoImage: UIImageView!
    
    @IBOutlet weak var uiTeamOneName: UILabel!
    @IBOutlet weak var uiTeamTwoName: UILabel!
    @IBOutlet weak var uiEventDate: UILabel!
    
    @IBOutlet weak var uiTeamTwoScore: UILabel!
    @IBOutlet weak var uiTeamOneScore: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
