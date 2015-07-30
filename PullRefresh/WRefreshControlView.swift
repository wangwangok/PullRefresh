//
//  WRefreshControlView.swift
//  PullRefresh
//
//  Created by Vivien on 15/7/30.
//  Copyright (c) 2015年 wangwang. All rights reserved.
//

import UIKit


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


/**
*  WRefreshControlViewDelegate 协议
*/
protocol WRefreshControlViewDelegate{
    func onChangeRefreshState(refreshControlView:WRefreshControlView)->WReFreshControlState
}


/// 刷新view,添加到你需要添加的地方
class WRefreshControlView: UIView {
    
    var delegate:WRefreshControlViewDelegate?
    /// 刷新状态
    var refreshState:WReFreshControlState = {
        return WReFreshControlState.Normal
    }()
    
    var targetContentSet:CGPoint={
        return CGPointZero
    }()
    
    @IBOutlet weak var stateLabel: UILabel!
    
    @IBOutlet weak var refreshImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    //MARK: - Public -
    func reloadData(){
        
        self.setNeedsDisplay()
    }
    
    //MARK: - Private -
    private func onChangeRefreshState(){
        
    }
}
