import UIKit

class LHSmallGiftManager: NSObject {
  
    var completeBlock : ((Bool)->())?
    var completeShowGifImageBlock : ((LHGiftModel)->())?
    
    let giftMaxNum  = 999
    
    static let shareManager = LHSmallGiftManager()
    
    //创建两个队列 最多显示两组小礼物
    lazy var giftQueue1: OperationQueue = {
        let giftQueue1 = OperationQueue()
        giftQueue1.maxConcurrentOperationCount = 1
        return giftQueue1
    }()
    
    lazy var giftQueue2: OperationQueue = {
        let giftQueue2 = OperationQueue()
        giftQueue2.maxConcurrentOperationCount = 1
        return giftQueue2
    }()
    
    lazy var giftQueue3: OperationQueue = {
        let giftQueue3 = OperationQueue()
        giftQueue3.maxConcurrentOperationCount = 1
        return giftQueue3
    }()
    
    //操作缓存池
    lazy var operationCache: NSCache<AnyObject,AnyObject> = {
        let operationCache = NSCache<AnyObject,AnyObject>()
        return operationCache
    }()
  
    let FrameW = 10 + showGiftView_UserIcon_LT + showGiftView_UserIcon_WH + showGiftView_UserName_L + showGiftView_UserName_W + showGiftView_GiftIcon_W + showGiftView_XNum_L + showGiftView_XNum_W
    
    lazy var smallGiftViewOne: LHSmallGiftView = {
        let smallGiftViewOne = LHSmallGiftView.init(frame: CGRect.init(x: -FrameW, y: 260, width: FrameW, height: 40))
        smallGiftViewOne.showViewKeyBlock = { model in
            self.curentGiftKeys.add(model.giftKey as Any)
           if let event = self.completeShowGifImageBlock {
                event(model)
            }
        }
        return smallGiftViewOne
    }()
    
    //  CGFloat showViewW = 10+showGiftView_UserIcon_LT+showGiftView_UserIcon_WH+showGiftView_UserName_L+showGiftView_UserName_W+showGiftView_GiftIcon_W+showGiftView_XNum_L+showGiftView_XNum_W;
    
    lazy var smallGiftViewSecond: LHSmallGiftView = {
        let smallGiftViewSecond = LHSmallGiftView.init(frame: CGRect.init(x: -FrameW, y: 310, width: FrameW, height: 40))
        smallGiftViewSecond.showViewKeyBlock = { model in
            self.curentGiftKeys.add(model.giftKey as Any)
           if let event = self.completeShowGifImageBlock {
                event(model)
            }
        }
        return smallGiftViewSecond
    }()
    
    lazy var smallGiftViewThree: LHSmallGiftView = {
        let smallGiftViewThree = LHSmallGiftView.init(frame: CGRect.init(x: -200, y: 360, width: 260, height: 40))
        smallGiftViewThree.showViewKeyBlock = { model in
            self.curentGiftKeys.add(model.giftKey as Any)
           if let event = self.completeShowGifImageBlock {
                event(model)
            }
        }
        return smallGiftViewThree
    }()
    
    
    
    
    /**当前礼物的唯一标识**/
    var curentGiftKeys : NSMutableArray = NSMutableArray()
    
    
    
  
    //送礼物(不处理第一次展示当前礼物逻辑)
    func showGiftViewWithBackView(_ view : UIView , _ giftModel : LHGiftModel, _ completeBlock : (()->())?)  {
        self.showGiftViewWithBackView(view, giftModel, completeBlock, nil)
    }
    //送礼物(回调第一次展示当前礼物的逻辑)
  private func showGiftViewWithBackView(_ view : UIView , _ giftModel : LHGiftModel, _ completeBlock : (()->())?, _ completeShowGifImageBlock : ((LHGiftModel)->())?)  {
      self.completeShowGifImageBlock = completeShowGifImageBlock
      if self.curentGiftKeys.count != 0 && self.curentGiftKeys.contains(giftModel.giftKey!) {
          if (self.operationCache.object(forKey: NSString.init(string: giftModel.giftKey!)) != nil) {
              //拿到当前礼物的信息
              let minOperation = self.operationCache.object(forKey: NSString.init(string: giftModel.giftKey!)) as! LHMinGiftOperation
               //限制一次礼物的连击最大值
              if minOperation.giftShowView?.currentGiftCount ?? 0 >= giftMaxNum {
                  //移除操作
                  self.operationCache.removeObject(forKey: NSString.init(string: giftModel.giftKey!))
                  self.curentGiftKeys.remove(giftModel.giftKey!)
              }else{
                  //赋值当前礼物数
                  minOperation.giftShowView?.giftCount = giftModel.sendCount
              }
          }else{
              var queue : OperationQueue?
              var showView : LHSmallGiftView?
             
              if self.giftQueue1.operations.count <= self.giftQueue2.operations.count {
                  queue = self.giftQueue1
                  showView = self.smallGiftViewOne
                  //showView?.model = giftModel
              }else{
                  queue = self.giftQueue2
                  showView = self.smallGiftViewSecond
              }
              
              
//              if self.giftQueue1.operations.count <= self.giftQueue2.operations.count {
//                  queue = self.giftQueue1
//                  showView = self.smallGiftViewOne
//                  //showView?.model = giftModel
//              }else if self.giftQueue2.operations.count <= self.giftQueue3.operations.count{
//                  queue = self.giftQueue2
//                  showView = self.smallGiftViewSecond
//                  //showView?.model = giftModel
//              }else{
//                  queue = self.giftQueue3
//                  showView = self.smallGiftViewThree
//                  //showView?.model = giftModel
//              }
              
              //当前操作已结束 重新创建
             // let operation = LHMinGiftOperation.init(showView!, view, giftModel)
//              operation.giftModel = giftModel
//              operation.giftShowView = showView
//              operation.containerView = view
             let  operation = LHMinGiftOperation.addOperationWithView(showView!, view, giftModel) { status, key in
                  if self.completeBlock != nil{
                      self.completeBlock!(status)
                  }
                  //移除操作
                  self.operationCache.removeObject(forKey: NSString.init(string: key))
                  self.curentGiftKeys.remove(key)
              }
              operation.giftModel?.defaultCount += giftModel.sendCount
              //存储操作信息
              self.operationCache.setObject(operation, forKey: NSString.init(string: giftModel.giftKey!))
              //操作加入队列
              queue?.addOperation(operation)
          }
      }else{
          //没有礼物的信息
          if (self.operationCache.object(forKey: NSString.init(string: giftModel.giftKey!)) != nil) {
              let minOperation = self.operationCache.object(forKey: NSString.init(string: giftModel.giftKey!)) as! LHMinGiftOperation
              if minOperation.giftModel?.defaultCount ?? 0 >= giftMaxNum {
                  //移除操作
                  self.operationCache.removeObject(forKey: NSString.init(string: giftModel.giftKey!))
                  self.curentGiftKeys.remove(giftModel.giftKey!)
              }else{
                  //赋值当前礼物数
                  minOperation.giftModel?.defaultCount += giftModel.sendCount
              }
              
          }else{
              var queue : OperationQueue?
              var showView : LHSmallGiftView?
//              if self.giftQueue1.operations.count <= self.giftQueue2.operations.count {
//                  queue = self.giftQueue1
//                  showView = self.smallGiftViewOne
//                  //showView?.model = giftModel
//              }else if self.giftQueue2.operations.count <= self.giftQueue3.operations.count{
//                  queue = self.giftQueue2
//                  showView = self.smallGiftViewSecond
//                  //showView?.model = giftModel
//              }else{
//                  queue = self.giftQueue3
//                  showView = self.smallGiftViewThree
//                  //showView?.model = giftModel
//              }
              if self.giftQueue1.operations.count <= self.giftQueue2.operations.count {
                  queue = self.giftQueue1
                  showView = self.smallGiftViewOne
                  //showView?.model = giftModel
              }else{
                  queue = self.giftQueue2
                  showView = self.smallGiftViewSecond
              }
              
              
              let operation = LHMinGiftOperation.addOperationWithView(showView!, view, giftModel) { status, key in
                  if self.completeBlock != nil{
                      self.completeBlock!(status)
                  }
                  if self.smallGiftViewOne.model?.giftKey == self.smallGiftViewSecond.model?.giftKey {
                      return
                  }
                  //移除操作
                  self.operationCache.removeObject(forKey: NSString.init(string: key))
                  self.curentGiftKeys.remove(key)
              }
              operation.giftModel?.defaultCount += giftModel.sendCount
              //存储操作信息
              self.operationCache.setObject(operation, forKey: NSString.init(string: giftModel.giftKey!))
              //操作加入队列
              queue?.addOperation(operation)
          }
      }
  }
}
