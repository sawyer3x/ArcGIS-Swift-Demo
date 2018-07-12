//
//  SegmentedViewController.swift
//  ArcGIS Swift Demo
//
//  Created by sawyer3x on 2018/7/12.
//  Copyright © 2018年 sawyer3x. All rights reserved.
//

import UIKit

class SegmentedViewController: UIViewController {

    @IBOutlet private weak var segmentedControl: UISegmentedControl!
    @IBOutlet private weak var infoContainerView: UIView!
    @IBOutlet private weak var codeContainerView: UIView!
    
    private var sourceCodeVC:SourceCodeViewController!
    private var sampleInfoVC:SampleInfoViewController!
    
    var filenames:[String]!
    var folderName:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    //MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SourceCodeSegue" { //321segue跳转了解一下
            let controller = segue.destination as! SourceCodeViewController
            controller.filenames = self.filenames
        } else if segue.identifier == "SampleInfoSegue" {
            let controller = segue.destination as! SampleInfoViewController
            controller.folderName = self.folderName
        }
    }
    
    //MARK: - Actions

    @IBAction func valueChanged(_ sender: UISegmentedControl) {
        self.infoContainerView.isHidden = (sender.selectedSegmentIndex == 1) //321这样的判断是否隐藏写法了解一下
    }
    
}
