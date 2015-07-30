//
//  WRefreshControl.swift
//  PullRefresh
//
//  Created by 王望 on 15/7/30.
//  Copyright (c) 2015年 wangwang. All rights reserved.
//

import UIKit
let kScreenWidth:CGFloat = UIScreen.mainScreen().bounds.width
/**
WReFreshControlState 刷新状态枚举

- Normal:  正常
- Pulling: 向下拉
- Success: 刷新成功
- Fail:    刷新失败
*/
enum WReFreshControlState:Int{
    
    case Normal     = 0
    case Pulling    = 1
    case Refreshing = 2
    case Success    = 4
    case Fail       = 5
}

protocol WRefreshControlDelegate{
    
}

class WRefreshControl: NSObject,UIScrollViewDelegate {
    
    private var kRefreshViewHeight:CGFloat = 50
    
    var delegate:WRefreshControlDelegate?
    
    private var refreshView:WRefreshControlView{

        return WRefreshControlView(frame: CGRectMake(0, -kRefreshViewHeight, kScreenWidth, kRefreshViewHeight))
    }
    
    convenience init(scrollView:UIScrollView,delegate:WRefreshControlDelegate){
        self.init()
        self.delegate = delegate
        scrollView.delegate = self
        scrollView.addSubview(refreshView)
    }
    
    //MARK: - ScrollView Delegate -
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
}
