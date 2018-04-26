//
//  CharacterDescriptionTableViewCell.swift
//  TABTest
//
//  Created by master on 4/22/18.
//  Copyright © 2018 neemo. All rights reserved.
//

import UIKit

/// Class that encapsulates the cell to display the description of the character as a string.
class CharacterDescriptionTableViewCell: UITableViewCell {
    /// The description label to display description
    @IBOutlet var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
