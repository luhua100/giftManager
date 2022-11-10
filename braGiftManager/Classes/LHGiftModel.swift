//
//  LHGiftModel.swift
//  HXStartScram
//
//  Created by zyfMac on 2022/8/4.
//

import UIKit

public class LHGiftModel: NSObject {

   public var picPath : String?
   public var id : String?
   public var giftName : String?
   public  var sendCount : Int = 1 //礼物发送个数
   public  var defaultCount : Int = 0 //默认个数
    var giftKey : String?{
        get{
            return  "\(id ?? "")\(giftName ?? "")"
        }
    }
    required  override init() {
        
    }
}
