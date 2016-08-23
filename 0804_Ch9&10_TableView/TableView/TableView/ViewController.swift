//
//  ViewController.swift
//  TableView
//
//  Created by Fan on 2016/8/21.
//  Copyright © 2016年 Luke. All rights reserved.
//

import UIKit
var Cell_ident = "PokemonCell"
class ViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var self_TableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self_TableView.dataSource = self
        self_TableView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Cell_ident,forIndexPath: indexPath) as! TableViewCell
        var index = indexPath.row+1
        cell.image_ImageView.image = UIImage(named: "pm00" + String(index))
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  10
    }

}

