//
//  LHLiveBrageView.swift
//  HXStartScram
//
//  Created by zyfMac on 2022/8/5.
//

import UIKit

//弹幕的状态
enum BarrageStatus : Int {
  case start, enter,end
}

let padding  = 10

class LHLiveBrageView: UIView {

    /**弹幕弹道 说白点就是frame.origin.y*/
    var barrageChannel : Int = 0
    
    /**弹幕的状态*/
    var barrageStatusBlock : ((BarrageStatus) ->())?
    
    lazy var titleNameLabel: UILabel = {
        let titleNameLabel = UILabel()
        titleNameLabel.font = UIFont.systemFont(ofSize: 14)
        titleNameLabel.numberOfLines = 0
        addSubview(titleNameLabel)
        return titleNameLabel
    }()
    
    //弹幕显示的内容
    func initWithBarrageName(_ content : String)  {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 5
        self.backgroundColor = .cyan
        self.titleNameLabel.text = content
        
        let str = NSString.init(string: content)
        let contentW =  str.size(withAttributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)]).width
        self.bounds = CGRect.init(x: 0, y: 0, width: Int(ceil(contentW)) + 2 * padding, height: 30)
        self.titleNameLabel.frame = CGRect.init(x: padding, y: 0, width: Int(ceil(contentW)), height: 30)
        
    }
    
    func startAnimation() {
        
        //动画的改变其实是改变 当前视图的X 坐标
        if let event = self.barrageStatusBlock {
            event(BarrageStatus.start)
        }
        let totalWidth = UIScreen.main.bounds.size.width + self.bounds.size.width
        // t = s / v
        let speed = totalWidth / 4
        let time = self.bounds.size.width / speed
        self.perform(#selector(enterStatus), with: nil, afterDelay: 5)
        var  frame = self.frame
        UIView.animate(withDuration: 4, delay: 0, options: .curveLinear) {
            frame.origin.x -= totalWidth
            self.frame = frame
        } completion: { status in
            self.removeFromSuperview()
            if let event = self.barrageStatusBlock {
                event(BarrageStatus.end)
            }
        }
    }
    
    func stopAnimation() {
        self.layer.removeAllAnimations()
        self.removeFromSuperview()
        NSObject.cancelPreviousPerformRequests(withTarget: self)
    }
    
    @objc func enterStatus(){
        if let event = self.barrageStatusBlock {
            event(BarrageStatus.enter)
        }
    }
    
}
