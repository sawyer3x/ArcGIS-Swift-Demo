//
//  CategoryCell.swift
//  ArcGIS Swift Demo
//
//  Created by sawyer3x on 2018/7/11.
//  Copyright © 2018年 sawyer3x. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var iconBackgroundView: UIView!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.iconBackgroundView.layer.cornerRadius = 25
        self.iconBackgroundView.layer.masksToBounds = true
    }
}
