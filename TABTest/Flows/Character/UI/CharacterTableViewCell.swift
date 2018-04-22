//
//  CharacterTableViewCell.swift
//  TABTest
//
//  Created by master on 4/22/18.
//  Copyright © 2018 neemo. All rights reserved.
//

import UIKit

protocol CharacterTableViewCellProtocol
{
    func shouldLayoutTable(cell : UITableViewCell)
}

class CharacterTableViewCell: UITableViewCell , AsyncImageViewProtocol {

    
    @IBOutlet var bgView: UIView!
    
    @IBOutlet var characterNameLabel: UILabel!
    
    @IBOutlet var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet var chacracterImageView: AsyncImageView!
    var delegate : CharacterTableViewCellProtocol!
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.imageViewHeightConstraint.constant = 0
        self.chacracterImageView.delegate = self
        // Initialization code
    }
    func imageDidLoad(size: CGSize)
    {
        
        if(self.delegate != nil)
        {
            self.delegate.shouldLayoutTable(cell : self)
        }
       
   }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
