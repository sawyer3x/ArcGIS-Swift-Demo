//
//  AppInfoViewController.swift
//  ArcGIS Swift Demo
//
//  Created by sawyer3x on 2018/7/12.
//  Copyright © 2018年 sawyer3x. All rights reserved.
//

import UIKit

class AppInfoViewController: UIViewController {

    @IBOutlet var appNameLabel:UILabel!
    @IBOutlet var appVersionLabel:UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
        let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        let buildNumber = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
        
        self.appNameLabel.text = appName
        self.appVersionLabel.text = "Built with ArcGIS Runtime SDK for iOS \(versionNumber!) (\(buildNumber!))"
        
        self.preferredContentSize = CGSize(width: 350, height: 350)
    }
    
    //MARK: - Actions
    
    @IBAction func closeAction() {
        self.dismiss(animated: true, completion: nil)
    }

}
