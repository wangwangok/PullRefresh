//
//  WLoadMoreControlView.swift
//  PullRefresh
//
//  Created by Vivien on 15/9/7.
//  Copyright (c) 2015年 wangwang. All rights reserved.
//

import UIKit

class WLoadMoreControlView: UIView {

  
  lazy private var stateLabel: UILabel = {
    return UILabel()
    }()
  
  lazy private var refreshImageView: UIImageView = {
    return UIImageView()
    }()
  
  /// 刷新状态
  var refreshState:WRefreshControlState = {
    return WRefreshControlState.Normal
    }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup(stateLabel, refreshImage: refreshImageView)
  }

  required init(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func reloadData(state:WRefreshControlState){
    self.onChangeRefreshState(state)
    self.refreshState = state
    self.setNeedsLayout()
  }
  
  //MARK: - Private -
  private func setup(label:UILabel, refreshImage imageView:UIImageView){
    label.font = UIFont.systemFontOfSize(12)
    label.textAlignment = NSTextAlignment.Center
    /// label的右边缘在self的中心
    label.frame = CGRectMake(self.frame.width/2, self.frame.height - 10 - 30, 100, 30)
    self.addSubview(label)
    
    imageView.center = CGPointMake(self.frame.width/2-16, stateLabel.center.y)
    imageView.bounds = CGRectMake(0, 0, 32, 32)
    var imagePath = kBundlePath+"/tableview_loading"
    imageView.image = UIImage(contentsOfFile: imagePath)
    self.addSubview(imageView)
    onChangeRefreshState(refreshState)
  }
  
  private func onChangeRefreshState(state:WRefreshControlState){
    /**
    *  移除无限循环动画
    */
    if(refreshImageView.layer.animationForKey("rotationAnimation") != nil){
      refreshImageView.layer.removeAnimationForKey("rotationAnimation")
    }
    stateLabel.center.x = self.center.x
    switch state.rawValue{
    case WRefreshControlState.Normal.rawValue:
      stateLabel.text = "上拉加载更多"
      refreshImageView.hidden = true
    case WRefreshControlState.Pulling.rawValue:
      stateLabel.text = "上拉加载更多"
      refreshImageView.hidden = true
    case WRefreshControlState.CanRefresh.rawValue:
      stateLabel.text = "松开即可加载"
      refreshImageView.hidden = true
    case WRefreshControlState.Refreshing.rawValue:
      refreshImageView.hidden   = false
      stateLabel.text           = "正在加载..."
      stateLabel.frame.origin.x = self.frame.width/2
      stateLabel.textAlignment  = NSTextAlignment.Left
      var imagePath             = kBundlePath+"/tableview_loading"
      refreshImageView.image    = UIImage(contentsOfFile: imagePath)
      animationWithCircle()
    default:
      break
    }
  }
  
  private func animationWithCircle(){
    
    var rotationAnimation:CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
    rotationAnimation.fromValue            = 0 as NSValue
    rotationAnimation.toValue              = M_PI * 2.0 as NSValue
    rotationAnimation.duration             = 0.8;
    rotationAnimation.cumulative           = true;
    rotationAnimation.repeatCount          = 1000;
    self.refreshImageView.layer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
  }
}
