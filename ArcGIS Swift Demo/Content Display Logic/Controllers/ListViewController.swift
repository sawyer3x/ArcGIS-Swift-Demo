//
//  ListViewController.swift
//  ArcGIS Swift Demo
//
//  Created by sawyer3x on 2018/7/12.
//  Copyright © 2018年 sawyer3x. All rights reserved.
//

import UIKit

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet private weak var tableView: UITableView!
    
    var list: [String]!
    
    private var selectAction: ((Int) -> Void)! //321这个和下面的啥玩意儿
    
    func setSelectAction(_ action: @escaping (Int) -> Void) {
        self.selectAction = action
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.layer.cornerRadius = 10
        self.tableView.clipsToBounds = true
    }

    //MARK: tableview data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list?.count ?? 0
    }
    
    //MARK: tableview delegate
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        
        cell.textLabel?.text = self.list[indexPath.row]
        cell.backgroundColor = .clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.selectAction != nil {
            self.selectAction(indexPath.row)
        }
    }
    
}
