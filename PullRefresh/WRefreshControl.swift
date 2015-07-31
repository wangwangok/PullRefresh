//
//  WRefreshControl.swift
//  PullRefresh
//
//  Created by 王望 on 15/7/30.
//  Copyright (c) 2015年 wangwang. All rights reserved.
//


import UIKit
let kScreenWidth:CGFloat = UIScreen.mainScreen().bounds.width

let kBundlePath:String = NSBundle.mainBundle().pathForResource("Refresh", ofType: "bundle")!

/**
WReFreshControlState 刷新状态枚举

- Normal:  正常
- Pulling: 向下拉
- Refreshing:刷新
- Success: 刷新成功
- Fail:    刷新失败
*/
/**
WReFreshControlState 刷新状态枚举

- Normal:     正常
- Pulling:    向下拉
- CanRefresh: 可以刷新
- Refreshing: 刷新
*/
enum WReFreshControlState:Int{
    
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

class WRefreshControl: NSObject,UIScrollViewDelegate {
    
    typealias StartClosure = ()->Void
    
    typealias FinishedClosure = (Bool)->Void
    
    weak var delegate:WRefreshControlDelegate?
    
    private var kRefreshViewHeight:CGFloat = 50
    
    private var startClosure:StartClosure?
    
    private var finishedClosure:FinishedClosure?
    
    private var scrollView:UIScrollView?
    
    private var refreshState:WReFreshControlState = WReFreshControlState.Normal
    
    private let targetOffSet:CGPoint = {
        return CGPointMake(0, -128)
    }()
    
    private var refreshView:WRefreshControlView!
    
    convenience init(scrollView:UIScrollView,delegate:WRefreshControlDelegate?){
        self.init()
        refreshView = WRefreshControlView(frame: CGRectMake(0, -kRefreshViewHeight, kScreenWidth, kRefreshViewHeight))
        self.scrollView = scrollView
        self.delegate = delegate
        self.scrollView!.delegate = self
        self.scrollView!.addSubview(refreshView)
    }
    
    //MARK: - Public -
    func startRefresh(refreshControl:WRefreshControl, start:StartClosure, complete:FinishedClosure){
        startClosure = start
        finishedClosure = complete
    }
    
    //MARK: - ScrollView Delegate -
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var state:WReFreshControlState?
        if(scrollView.contentOffset.y <= targetOffSet.y){
            state = WReFreshControlState.CanRefresh
        }else{
            state = WReFreshControlState.Pulling
        }
        refreshView.reloadData(state!)
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        if(scrollView.contentInset.top == -targetOffSet.y){
            scrollView.contentInset.top = 64
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if(scrollView.contentOffset.y <= targetOffSet.y){
            //从这里开始进入刷新状态
            scrollView.contentInset.top = -targetOffSet.y
            //self.scrollView!.contentOffset = CGPointMake(0, targetOffSet.y)
            startClosure?()
        }
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var state:WReFreshControlState?
        state = WReFreshControlState.Refreshing
        if(scrollView.contentInset.top == -targetOffSet.y){
            state = WReFreshControlState.Refreshing
        }else{
            state = WReFreshControlState.Normal
        }
        refreshView.reloadData(state!)
        
        
    }
}
