//
//  ViewController.swift
//  PullRefresh
//
//  Created by Vivien on 15/7/30.
//  Copyright (c) 2015年 wangwang. All rights reserved.
//

import UIKit

class ViewController: UIViewController,WRefreshControlDelegate {
  
  @IBOutlet weak var tableVIew: UITableView!
  var refreshControl:WRefreshControl?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    refreshControl = WRefreshControl(scrollView: self.tableVIew, delegate: self, timeoutInterval: 3.0)
    refreshControl!.startRefresh()
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func endRefresh(sender: UIBarButtonItem) {
    refreshControl!.endRefresh()
  }
  
  
  //MARK: - TableView Delegate And DataSource -
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 20
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    var cell = tableView.dequeueReusableCellWithIdentifier("cell") as? UITableViewCell
    if(cell == nil){
      cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
    }
    cell?.textLabel?.text = "第\(indexPath.row)行"
    return cell!
  }
}

extension ViewController:WRefreshControlDelegate{
  func refreshControlWillStartRefresh(refreshControl: WRefreshControl) {
    println("refreshControlWillStartRefresh")
  }
  
  func refreshControlDidStartRefresh(refreshControl: WRefreshControl) {
    println("refreshControlDidStartRefresh")
  }
  
  func refreshControlWillFinishedRefresh(refreshControl: WRefreshControl) {
    println("refreshControlWillFinishedRefresh")
  }
  
  func refreshControlDidFinishedRefresh(refreshControl: WRefreshControl) {
    println("refreshControlDidFinishedRefresh")
  }
}

