//
//  Node.swift
//  ArcGIS Swift Demo
//
//  Created by sawyer3x on 2018/7/11.
//  Copyright © 2018年 sawyer3x. All rights reserved.
//

import UIKit

class Node: NSObject {
    
    var displayName: String = ""
    var descriptionText: String = ""
    var storyboardName: String!  //if nil, then use content table VC
    var children: [Node]!  //if nil, then root node
    var dependency = [String]()
    //    var readmeURLString:String!
    
    
}
