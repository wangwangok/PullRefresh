//
//  WRefreshControlView.swift
//  PullRefresh
//
//  Created by Vivien on 15/7/30.
//  Copyright (c) 2015年 wangwang. All rights reserved.
//

import UIKit

/// 刷新view,添加到你需要添加的地方
class WRefreshControlView: UIView {
  let kDistanceOfLabelAndImageView:CGFloat = 10
  /// 刷新状态
  var refreshState:WRefreshControlState = {
    return WRefreshControlState.Normal
    }()
  
  var targetContentSet:CGPoint={
    return CGPointZero
    }()
  
  lazy private var stateLabel: UILabel = {
    return UILabel()
    }()
  
  lazy private var refreshImageView: UIImageView = {
    return UIImageView()
    }()
  
  private var timer:NSTimer?
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    /**
    控件到下方的距离固定
    */
    self.backgroundColor = UIColor.clearColor()
    stateLabel.font = UIFont.systemFontOfSize(12)
    stateLabel.textAlignment = NSTextAlignment.Left
    /// label的右边缘在self的中心
    stateLabel.frame = CGRectMake(self.frame.width/2, self.frame.height - kDistanceOfLabelAndImageView - 30, 100, 30)
    self.addSubview(stateLabel)
    
    refreshImageView.center = CGPointMake(self.frame.width/2-16, stateLabel.center.y)
    refreshImageView.bounds = CGRectMake(0, 0, 32, 32)
    var imagePath = kBundlePath+"/tableview_pull_refresh"
    refreshImageView.image = UIImage(contentsOfFile: imagePath)
    self.addSubview(refreshImageView)
    onChangeRefreshState(refreshState)
  }
  required init(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func reloadData(state:WRefreshControlState){
    self.onChangeRefreshState(state)
    self.refreshState = state
    self.setNeedsLayout()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
  }
  
  //MARK: - Private -
  private func onChangeRefreshState(state:WRefreshControlState){
    /**
    *  移除无限循环动画
    */
    if(refreshImageView.layer.animationForKey("rotationAnimation") != nil){
      refreshImageView.layer.removeAnimationForKey("rotationAnimation")
    }
    
    switch state.rawValue{
    case WRefreshControlState.Normal.rawValue:
      stateLabel.text = "下拉刷新"
      var imagePath = kBundlePath+"/tableview_pull_refresh"
      refreshImageView.image = UIImage(contentsOfFile: imagePath)
    case WRefreshControlState.Pulling.rawValue:
      animationWithLabelAndImageView("下拉刷新", pi: -CGFloat(0))
    case WRefreshControlState.CanRefresh.rawValue:
      animationWithLabelAndImageView("释放更新", pi: CGFloat(M_PI))
    case WRefreshControlState.Refreshing.rawValue:
      self.stateLabel.text        = "加载中..."
      var imagePath               = kBundlePath+"/tableview_loading"
      self.refreshImageView.image = UIImage(contentsOfFile: imagePath)
      animationWithCircle()
    default:
      break
    }
  }
  
  private func animationWithLabelAndImageView(text:String ,pi:CGFloat){
    UIView.animateWithDuration(0.3, animations: { () -> Void in
      self.stateLabel.text = text
      var imagePath = kBundlePath+"/tableview_pull_refresh"
      self.refreshImageView.image = UIImage(contentsOfFile: imagePath)
      self.refreshImageView.transform = CGAffineTransformMakeRotation(pi)
      }, completion: { (Bool) -> Void in
        
    })
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
