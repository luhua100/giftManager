//
//  LHBarageManager.swift
//  HXStartScram
//
//  Created by zyfMac on 2022/8/5.
//

import UIKit

public class LHBarageManager: NSObject {
    //数据源
   public var sourceArray  : NSMutableArray = NSMutableArray.init()
    //弹幕的数组
    var barraArray  : NSMutableArray = NSMutableArray.init()
    //存储弹幕的view
    var barraViewsArray  : NSMutableArray = NSMutableArray.init()
    //是否停止
    var stopAnimation : Bool  = true
    
  public  var startCreatBarrageBlock : ((LHLiveBrageView) ->())?
    override init() {
        super.init()
        stopAnimation = true
    }
    
    func start() {
        if !self.stopAnimation { //已经在开始没必要操作
            return
        }
        stopAnimation = false
        self.barraArray.removeAllObjects()
        self.barraArray.addObjects(from: self.sourceArray as! [Any])
        //随机生成弹幕的view
        initBrageView()
    }
  public  func stop() {
        if self.stopAnimation == true {
            return
        }
        self.stopAnimation = true
        self.barraViewsArray.enumerateObjects { obj, idx, status in
            var view = obj as? LHLiveBrageView
            view?.stopAnimation()
            view = nil
        }
        //清空数组 恢复到初始状态
        self.barraViewsArray.removeAllObjects()
    }
    
    func nextCommentData() -> String? {
        if self.barraArray.count == 0 {
            return nil
        }
        //移除第一个 追加一个弹幕在后面
        let data = self.barraArray.firstObject
        if data != nil {
            self.barraArray.removeObject(at: 0)
        }
        return data as? String
    }
  
    func initBrageView() {
        let channelArray = NSMutableArray.init(array: [1,2,3])
        if self.barraArray.count != 0 {
            let count = self.barraArray.count > 3 ? 3 : self.barraArray.count
            for _ in 0..<count{
                let arcValue = arc4random() %   UInt32(channelArray.count)
                let arcY : Int = channelArray.object(at: Int(arcValue)) as! Int
                channelArray.removeObject(at: Int(arcValue))
                //从弹幕数组逐一取出数据
                let data = self.barraArray.firstObject as! String
                self.barraArray.removeObject(at: 0)
                //创建弹幕视图
                self.create(data, channel: arcY)
            }
        }
    }
    
    func create(_ data : String , channel : Int)  {
        if self.stopAnimation == true {
            return
        }
        let view = LHLiveBrageView()
        view.initWithBarrageName(data)
        view.barrageChannel = channel
        self.barraViewsArray.add(view)
        view.barrageStatusBlock = { status in
            if self.stopAnimation == true {
                return
            }
            if status == .start {
                self.barraViewsArray.add(view)
            }
            else if status == .end {
                if self.barraViewsArray.contains(view) {
                    view.stopAnimation()
                    self.barraViewsArray.remove(view)
                }
                if self.barraViewsArray.count == 0 {
                    //屏幕上没有弹幕了 此时循环
                    self.stopAnimation = true
                    self.start()
                }
            }else{
                //弹幕完全进入屏幕的时候 判断是否还有下一条 如果有就继续追加
                let comment = self.nextCommentData()
                if comment != nil {
                    self.create(comment!, channel: channel)
                }
            }
        }
        if let event = self.startCreatBarrageBlock {
            event(view)
        }
    }
    
}
