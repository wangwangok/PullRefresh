//
//  WLoadMoreControl.swift
//  PullRefresh
//
//  Created by Vivien on 15/9/7.
//  Copyright (c) 2015年 wangwang. All rights reserved.
//

/// 预计支持自动加载更多和手动加载更多
import UIKit

enum WLoadMoreType:Int{
  
  case Automatic = 0 /// 自动加载更多
  
  case Manual    = 1 /// 手动拉动致使加载更多
}

@objc protocol WLoadMoreControlDelegate{
  
  /**
  已经开始刷新
  
  :param: loadMoreControl loadMoreControl
  
  :returns: Void
  */
  optional func loadMoreControlDidStartRefresh(loadMoreControl:WLoadMoreControl)->Void
  
  /**
  已经结束刷新
  
  :param: loadMoreControl loadMoreControl
  
  :returns: Void
  */
  optional func loadMoreControlDidFinishedRefresh(loadMoreControl:WLoadMoreControl)->Void
}

class WLoadMoreControl: NSObject {
  
  weak var delegate:WLoadMoreControlDelegate?
  
  /// 默认手动加载
  private var loadMoreType = WLoadMoreType.Manual
  
  /// 默认的加载更多视图的高度
  private let kLoadMoreViewHeight:CGFloat = 50
  
  /// 滑动到底部，再向上拉enableLoadSety高度即可进入刷新状态
  private let enableLoadSety:CGFloat = 64
  
  private var scrollView:UIScrollView?
  
  private var loadMoreView:WLoadMoreControlView?
  
  private var maxContenOfsety:CGFloat = 0
  
  private var loadState:WRefreshControlState?
  
  /**
  初始化加载更多
  
  :param: scrollView 需要使用加载更多的滑动视图
  :param: type       加载的方式，可以为空，为空则默认手动加载
  
  :returns:
  */
  convenience init(scrollView:UIScrollView,loadMoreDelegate delegate:WLoadMoreControlDelegate, loadMoreType type:WLoadMoreType?){
    self.init()
    self.scrollView           = scrollView
    self.scrollView!.delegate = self
    self.delegate             = delegate
    self.scrollView!.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.New | NSKeyValueObservingOptions.Old, context: nil)
    self.scrollView!.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.New | NSKeyValueObservingOptions.Old, context: nil)
    if type != nil{
      loadMoreType = type!
    }
  }
  
  override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
    if loadMoreView == nil {
      initBottomView()
      return
    }
  }
  //MARK: - Private -
  private func initBottomView(){
    let y = max(scrollView!.bounds.height, scrollView!.contentSize.height)
    loadMoreView = WLoadMoreControlView(frame: CGRectMake(0, y, kScreenWidth, kLoadMoreViewHeight))
    scrollView!.addSubview(loadMoreView!)
    maxContenOfsety = y - kScreenHeight
  }
  
  private func changeStateWithRefreingAndNormal(scrollView: UIScrollView){
    if(scrollView.contentInset.bottom == enableLoadSety){
      if loadState != WRefreshControlState.Refreshing {
        loadState = WRefreshControlState.Refreshing
        self.delegate?.loadMoreControlDidStartRefresh?(self)
      }
    }else{
      loadState = WRefreshControlState.Normal
    }
    loadMoreView?.reloadData(loadState!)
  }
  
  private func resetContentInSetTop(scrollView: UIScrollView){
    if(scrollView.contentOffset.y - maxContenOfsety >= enableLoadSety){
      UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
        scrollView.contentInset.bottom = self.enableLoadSety
        }, completion: nil)
    }
  }
  
  private func changContenInSetTopToNormal(scrollView: UIScrollView){
    
    if(scrollView.contentInset.bottom == enableLoadSety){
      
      UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
        scrollView.contentInset.bottom = 0
        }, completion: { (Bool) -> Void in
          
      })
    }
  }
  
  //MARK: - Public -
  
  /**
  开始刷新
  */
  func startload(){
    scrollView!.contentOffset.y = enableLoadSety
    resetContentInSetTop(scrollView!)
    changContenInSetTopToNormal(scrollView!)
  }
  
  /**
  停止刷新
  */
  func endload(){
    changContenInSetTopToNormal(scrollView!)
    self.delegate?.loadMoreControlDidFinishedRefresh?(self)
    self.loadMoreView!.removeFromSuperview()
    self.loadMoreView = nil
  }
}


//MARK: - ScrollView Delegate -
extension WLoadMoreControl:UIScrollViewDelegate{
  
  func scrollViewDidScroll(scrollView: UIScrollView) {
    if scrollView != self.scrollView {
      return
    }
    if (scrollView.contentInset.bottom == enableLoadSety){
    
    }else{
      if scrollView.contentOffset.y - maxContenOfsety >= enableLoadSety{
        loadMoreView?.reloadData(WRefreshControlState.CanRefresh)
      }else{
        loadMoreView?.reloadData(WRefreshControlState.Normal)
      }
    }
  }
  
  func scrollViewWillBeginDragging(scrollView: UIScrollView) {
    
  }

  func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if scrollView != self.scrollView {
      return
    }
    resetContentInSetTop(scrollView)
    changeStateWithRefreingAndNormal(scrollView)
  }
}
