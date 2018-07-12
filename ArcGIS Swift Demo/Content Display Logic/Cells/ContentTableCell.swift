//
//  ContentTableCell.swift
//  ArcGIS Swift Demo
//
//  Created by sawyer3x on 2018/7/12.
//  Copyright © 2018年 sawyer3x. All rights reserved.
//

import UIKit

class ContentTableCell: UITableViewCell {

    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var detailLabel:UILabel!
    @IBOutlet var infoButton:UIButton!
    @IBOutlet var parentView:UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        parentView.layer.borderColor = UIColor(white: 0.85, alpha: 1).cgColor
        parentView.layer.borderWidth = 1
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        if highlighted {
            self.parentView.backgroundColor = .secondaryBlue
            self.titleLabel.textColor = .white
            self.detailLabel.textColor = .white
            self.infoButton.tintColor = .white
        }
        else {
            self.parentView.backgroundColor = .white
            self.titleLabel.textColor = .primaryTextColor
            self.detailLabel.textColor = .secondaryTextColor
            self.infoButton.tintColor = .secondaryBlue
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        if selected {
            self.parentView.backgroundColor = .secondaryBlue
            self.titleLabel.textColor = .white
            self.detailLabel.textColor = .white
            self.infoButton.tintColor = .white
        } else {
            self.parentView.backgroundColor = .white
            self.titleLabel.textColor = .primaryTextColor
            self.detailLabel.textColor = .secondaryTextColor
            self.infoButton.tintColor = .secondaryBlue
        }
    }
    
}
