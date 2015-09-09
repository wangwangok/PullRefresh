//
//  ViewController.swift
//  PullRefresh
//
//  Created by Vivien on 15/7/30.
//  Copyright (c) 2015年 wangwang. All rights reserved.
//

import UIKit

class ViewController: UIViewController,WRefreshControlDelegate {
  
  @IBOutlet weak var tableView: UITableView!
  
  var refreshControl:WRefreshControl?
  
  var loadMoreControl:WLoadMoreControl?
  
  var number:Int = 20
  
  override func viewDidLoad() {
    super.viewDidLoad()
    refreshControl = WRefreshControl(scrollView: self.tableView, delegate: self, timeoutInterval: 3.0)
    
    refreshControl!.startRefresh()
    
    //loadMoreControl = WLoadMoreControl(scrollView: self.tableView, loadMoreDelegate: self, loadMoreType: nil)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  @IBAction func endRefresh(sender: UIBarButtonItem) {
    refreshControl!.endRefresh()
    //loadMoreControl!.endload()
  }
  
  //MARK: - TableView Delegate And DataSource -
  func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return number
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
    println("-----refreshControlWillStartRefresh")
  }
  
  func refreshControlDidStartRefresh(refreshControl: WRefreshControl) {
    println("<<<<<<refreshControlDidStartRefresh")
  }
  
  func refreshControlWillFinishedRefresh(refreshControl: WRefreshControl) {
    println(">>>>>>>refreshControlWillFinishedRefresh")
  }
  
  func refreshControlDidFinishedRefresh(refreshControl: WRefreshControl) {
    println("~~~~~~~refreshControlDidFinishedRefresh")
  }
}

extension ViewController:WLoadMoreControlDelegate{
  func loadMoreControlDidStartRefresh(loadMoreControl: WLoadMoreControl) {
    println("-----loadMoreControlDidStartRefresh------")
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(3.0) * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
      
    }
  }
  
  func loadMoreControlDidFinishedRefresh(loadMoreControl: WLoadMoreControl) {
    println("loadMoreControlDidFinishedRefresh")
    self.number += 10
    self.tableView.reloadData()
  }
}

