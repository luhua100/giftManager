//
//  LHGiftModel.swift
//  HXStartScram
//
//  Created by zyfMac on 2022/8/4.
//

import UIKit

class LHGiftModel: NSObject {

    var picPath : String?
    var id : String?
    var giftName : String?
    var sendCount : Int = 1 //礼物发送个数
    var defaultCount : Int = 0 //默认个数
    var giftKey : String?{
        get{
            return  "\(id ?? "")\(giftName ?? "")"
        }
    }
    required  override init() {
        
    }
}
