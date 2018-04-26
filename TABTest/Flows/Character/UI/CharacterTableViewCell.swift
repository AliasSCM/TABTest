//
//  CharacterTableViewCell.swift
//  TABTest
//
//  Created by master on 4/22/18.
//  Copyright © 2018 neemo. All rights reserved.
//

import UIKit

/// Protocol to convey if containing table view should need a load in layout
protocol CharacterTableViewCellProtocol
{
    /// Function to layout table if cell changes
    /// - parameter : The tableview cell
    func shouldLayoutTable(cell : UITableViewCell)
}

/// Character table view class that encapsulates the display of showing the character entity in a table view cell
/// - important : Should implement AsyncImageViewProtocol as it has a property of AsyncImage view. This cell resizes itself depending on size of image downloaded.
class CharacterTableViewCell: UITableViewCell , AsyncImageViewProtocol {
    /// The background view of the cell.
    @IBOutlet var bgView: UIView!
    /// The label to show the name of the character
    @IBOutlet var characterNameLabel: UILabel!
    /// the height constraint of the image view. This is used to resize the image view depending on image size
    @IBOutlet var imageViewHeightConstraint: NSLayoutConstraint!
    /// the image view that shows the characters image
    @IBOutlet var chacracterImageView: AsyncImageView!
    /// delegate that conveys when containing table view should load
    var delegate : CharacterTableViewCellProtocol!
    override func awakeFromNib() {
        super.awakeFromNib()
        //self.imageViewHeightConstraint.constant = 0
        self.chacracterImageView.delegate = self
        // Initialization code
    }
    /// Function to handle when async image has been loaded. Implementing AsyncImageProtocol
    /// - parameter size: Size of the image downloaded
    func imageDidLoad(size: CGSize){
        if(self.delegate != nil){
            self.delegate.shouldLayoutTable(cell : self)
        }
    }
}
