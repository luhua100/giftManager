//
//  LHMinGiftOperation.swift
//  HXStartScram
//
//  Created by zyfMac on 2022/8/4.
//

import UIKit

class LHMinGiftOperation: Operation {
   
    var giftShowView : LHSmallGiftView? //小礼物的视图
    var containerView : UIView? //承载的视图
    var giftModel : LHGiftModel? //礼物的模型
    var completeOpBlock : ((Bool,String) ->())?
    private var _executing : Bool = false
    override var isExecuting : Bool {
        get { return _executing }
        set { guard _executing != newValue else { return }
            willChangeValue(forKey: "isExecuting")
            _executing = newValue
            didChangeValue(forKey: "isExecuting")
            
        }
    }
    private var _finished : Bool = false
    override var isFinished : Bool {
        get { return _finished }
        set { guard _finished != newValue else { return }
            willChangeValue(forKey: "isFinished")
            _finished = newValue
            didChangeValue(forKey: "isFinished") }
    }
    
    
    override init() {
        _executing = false
        _finished = false
    }
    
   
    
    func initData(_ giftShowView : LHSmallGiftView , _ containerView: UIView , _ giftModel: LHGiftModel ,_ completeBlock : ((Bool,String) ->())?) -> LHMinGiftOperation{
         let op = LHMinGiftOperation()
        op.giftModel = giftModel
        op.giftShowView = giftShowView
        op.completeOpBlock = completeBlock
        op.containerView = containerView
        return op
    }
    
    
    static func addOperationWithView(_ view : LHSmallGiftView, _ containerView : UIView , _ giftModel : LHGiftModel , _ completeBlock : ((Bool,String) ->())?) -> LHMinGiftOperation {
        return LHMinGiftOperation().initData(view, containerView, giftModel, completeBlock)
    }
    
    override func start() {
        if self.isCancelled {
            _finished = true
            return
        }
        _executing = true
        OperationQueue.main.addOperation {
            self.containerView?.addSubview(self.giftShowView!)
            self.giftShowView?.showGiftShowViewWithModel(self.giftModel!, completeBlock: { finished, giftKey in
                self.isFinished = finished
                if self.completeOpBlock != nil {
                    self.completeOpBlock!(finished,giftKey)
                }
            })
        }
    }
    
}
