//
//  WRefreshControl.swift
//  PullRefresh
//
//  Created by Vivien on 15/7/30.
//  Copyright (c) 2015年 wangwang. All rights reserved.
//


import UIKit
let kScreenWidth:CGFloat = UIScreen.mainScreen().bounds.width

let kScreenHeight:CGFloat = UIScreen.mainScreen().bounds.height

let kBundlePath:String = NSBundle.mainBundle().pathForResource("Refresh", ofType: "bundle")!

/**
WReFreshControlState 刷新状态枚举

- Normal:     正常
- Pulling:    向下拉
- CanRefresh: 可以刷新
- Refreshing: 刷新
*/
enum WRefreshControlState:Int{
  
  case Normal     = 0
  case Pulling    = 1
  case CanRefresh = 2
  case Refreshing = 3
}

@objc protocol WRefreshControlDelegate{
  /**
  将要开始刷新
  
  :param: refreshControl refreshControl
  
  :returns: Void
  */
  optional func refreshControlWillStartRefresh(refreshControl:WRefreshControl)->Void
  
  /**
  已经开始刷新
  
  :param: refreshControl refreshControl
  
  :returns: Void
  */
  optional func refreshControlDidStartRefresh(refreshControl:WRefreshControl)->Void
  
  /**
  将要结束刷新
  
  :param: refreshControl refreshControl
  
  :returns: Void
  */
  optional func refreshControlWillFinishedRefresh(refreshControl:WRefreshControl)->Void
  
  /**
  已经结束刷新
  
  :param: refreshControl refreshControl
  
  :returns: Void
  */
  optional func refreshControlDidFinishedRefresh(refreshControl:WRefreshControl)->Void
}

class WRefreshControl: NSObject {
  
  weak var delegate:WRefreshControlDelegate?
  
  private let kRefreshViewHeight:CGFloat = 50
  
  private var scrollView:UIScrollView?
  
  private var refreshState:WRefreshControlState?
  
  private let targetOffSet:CGPoint = {
    return CGPointMake(0, -128)
    }()
  private var timeoutInterval:NSTimeInterval?
  
  private var refreshView:WRefreshControlView!
  /// 手动拉动刷新
  private var isManualRefresh:Bool = false
  
  private var timeout:NSDate!
  
  private var timer:NSTimer?
  
  convenience init(scrollView:UIScrollView,delegate:WRefreshControlDelegate?,timeoutInterval:Double?){
    self.init()
    self.timeoutInterval      = timeoutInterval == nil ? 10.0 : timeoutInterval//默认的超时时长为10s
    self.timeout              = NSDate(timeIntervalSinceNow: self.timeoutInterval!)
    refreshView               = WRefreshControlView(frame: CGRectMake(0, -kRefreshViewHeight, kScreenWidth, kRefreshViewHeight))
    self.scrollView           = scrollView
    self.delegate             = delegate
    self.scrollView!.delegate = self
    self.scrollView!.addSubview(refreshView)
  }
  
  //MARK: - Public -
  /**
  用户手动开启刷新
  */
  func startRefresh(){
    isManualRefresh = true
    self.scrollView!.contentOffset.y = targetOffSet.y
    resetContentInSetTop(self.scrollView!)
    changContenInSetTopToNormal(self.scrollView!)
  }
  
  /**
  用户手动关闭刷新动画
  
  :param: refreshControl 刷新控件
  :param: complete       完成
  :param: failed         失败
  */
  func endRefresh(){
    self.delegate?.refreshControlWillFinishedRefresh?(self)
    changContenInSetTopToNormal(self.scrollView!)
    self.delegate?.refreshControlDidFinishedRefresh?(self)
  }
  
  //MARK: - Private -
  func timer(timer:NSTimer){
    
    dispatch_async(dispatch_get_main_queue(), { () -> Void in
      println("timeout:\(self.timeout),nsdate:\(NSDate())")
      if NSDate.timeIntervalSinceReferenceDate() >= self.timeout.timeIntervalSinceReferenceDate{
        self.endRefresh()
        self.timer?.invalidate()
        self.timer = nil
      }
    })
  }
  
  private func resetContentInSetTop(scrollView: UIScrollView){
    if(scrollView.contentOffset.y <= targetOffSet.y){
      //从这里开始进入刷新状态
      self.delegate?.refreshControlWillStartRefresh?(self)
      UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
        scrollView.contentInset.top = -self.targetOffSet.y
        }, completion: nil)
    }
  }
  
  private func changeStateWithRefreingAndNormal(scrollView: UIScrollView){
   // var state:WRefreshControlState?
    if(scrollView.contentInset.top == -targetOffSet.y){
      if refreshState != WRefreshControlState.Refreshing {
        refreshState = WRefreshControlState.Refreshing
        self.delegate?.refreshControlDidStartRefresh?(self)
      }
      timer = NSTimer.scheduledTimerWithTimeInterval(self.timeoutInterval!, target: self, selector: "timer:", userInfo: nil, repeats: false)
      NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
    }else{
      refreshState = WRefreshControlState.Normal
    }
    refreshView.reloadData(refreshState!)
  }
  
  private func changeStateWithRefreshingAndPulling(scrollView: UIScrollView,refreshView:WRefreshControlView){
    if(scrollView.contentInset.top == -targetOffSet.y){
      if isManualRefresh == false{
        return
      }
      changeStateWithRefreingAndNormal(scrollView)
    }else{
      if(scrollView.contentOffset.y <= targetOffSet.y){
        refreshView.reloadData(WRefreshControlState.CanRefresh)
      }else if(scrollView.contentInset.top != -targetOffSet.y){
        refreshView.reloadData(WRefreshControlState.Pulling)
      }
    }
  }
  
  private func changContenInSetTopToNormal(scrollView: UIScrollView){
    
    if(scrollView.contentInset.top == -targetOffSet.y){
      
      UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
        scrollView.contentInset.top = 64
        }, completion: { (Bool) -> Void in
          
      })
    }
  }
}

extension WRefreshControl:UIScrollViewDelegate{
  
  //MARK: - ScrollView Delegate -
  func scrollViewDidScroll(scrollView: UIScrollView) {
    changeStateWithRefreshingAndPulling(scrollView, refreshView: self.refreshView!)
  }
  
  func scrollViewWillBeginDragging(scrollView: UIScrollView) {
    isManualRefresh = false
    //changContenInSetTopToNormal(scrollView)
  }
  
  func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    resetContentInSetTop(scrollView)
    changeStateWithRefreingAndNormal(scrollView)
  }
}
