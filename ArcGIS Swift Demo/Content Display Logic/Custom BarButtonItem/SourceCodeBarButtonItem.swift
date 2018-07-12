//
//  SourceCodeBarButtonItem.swift
//  ArcGIS Swift Demo
//
//  Created by sawyer3x on 2018/7/12.
//  Copyright © 2018年 sawyer3x. All rights reserved.
//

import UIKit

class SourceCodeBarButtonItem: UIBarButtonItem {

    var fileNames: [String]!
    var folderName: String!
    weak var navController: UINavigationController?
    
    override init() {
        super.init()
        
        self.image = UIImage(named: "InfoIcon")
        self.target = self
        self.action = #selector(SourceCodeBarButtonItem.showSegmentedVC)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func showSegmentedVC() { //321为何要加@objc 不加会怎么样
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "SegmentedViewController") as! SegmentedViewController
        controller.filenames = filenames
        controller.folderName = self.folderName
        self.navController?.show(controller, sender: self)
    }
    
}
