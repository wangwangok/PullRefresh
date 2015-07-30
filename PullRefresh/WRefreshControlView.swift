//
//  WRefreshControlView.swift
//  PullRefresh
//
//  Created by Vivien on 15/7/30.
//  Copyright (c) 2015年 wangwang. All rights reserved.
//

import UIKit


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
    
    private var stateLabel: UILabel!
    
    private var refreshImageView: UIImageView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    //MARK: - Public -
    func reloadData(){
        
        self.setNeedsDisplay()
    }
    
    //MARK: - Private -
    private func onChangeRefreshState(){
        
    }
}
