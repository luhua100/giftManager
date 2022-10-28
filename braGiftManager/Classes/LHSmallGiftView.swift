//
//  LHSmallGiftView.swift
//  HXStartScram
//
//  Created by zyfMac on 2022/8/4.
//

import UIKit

let showGiftView_UserIcon_WH  = 34.0 //头像宽高
let showGiftView_UserName_W  = 60.0 //名字宽 -
let showGiftView_UserName_H  = 16.0 //名字高 -
let showGiftView_UserName_L  = 2.0 //名字左
let showGiftView_GiftIcon_H  = 40.0 //图片高
let showGiftView_GiftIcon_W  = 40.0 //图片宽
var showGiftView_UserIcon_LT  = 3.0 //头像距离上/左
let showGiftView_XNum_W  = 60.0 //礼物数宽
let showGiftView_XNum_H  = 30.0 //礼物数高
let showGiftView_XNum_L  = 5.0 //礼物数左

class LHSmallGiftView: UIView {
    
    
    lazy var bgView: UIView = { [weak self] in
        let bgView = UIView()
        bgView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        bgView.layer.cornerRadius = 20
        bgView.layer.masksToBounds = true
        return bgView
    }()
    
    lazy var userIconView: UIImageView = { [weak self] in
        let userIconView = UIImageView()
        userIconView.layer.cornerRadius = showGiftView_UserIcon_WH / 2
        userIconView.layer.masksToBounds = true
        return userIconView
    }()
    
    lazy var userNameLabel: UILabel = { [weak self] in
        let userNameLabel = UILabel()
        userNameLabel.textColor = .white
        userNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        return userNameLabel
    }()
    
    lazy var giftNameLabel: UILabel = {  [weak self] in
        let giftNameLabel = UILabel()
        giftNameLabel.textColor = .white
        giftNameLabel.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        return giftNameLabel
    }()
    
    lazy var giftImageView: UIImageView = { [weak self] in
        let  giftImageView = UIImageView()
        return giftImageView
    }()
    
    lazy var countLabel: LHMinBorderLabel = { [weak self] in
        let  countLabel = LHMinBorderLabel()
        countLabel.textColor = UIColor(red: 255.0 / 255, green: 213.0 / 255, blue: 76.0 / 255, alpha: 1)
        countLabel.borderColor =  UIColor(red: 163.0 / 255, green: 96.0 / 255, blue: 51.0 / 255, alpha: 1)
        countLabel.font = UIFont.boldSystemFont(ofSize: 25)
        countLabel.textAlignment = .center
        return countLabel
    }()
    
    
    /** 礼物数 */
    var giftCount : Int = 0{
        didSet{
            print("----------------------**\(giftCount)")
            self.currentGiftCount += giftCount
            self.countLabel.text = " X\(currentGiftCount)"
            if self.currentGiftCount > 1 {
                self.showAnimation(countLabel)
                NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(hiddenGiftShowView), object: nil)
                self.perform(#selector(hiddenGiftShowView), with: nil, afterDelay: 5)
            }else{
                self.perform(#selector(hiddenGiftShowView), with: nil, afterDelay: 5)
            }
        }
    }
    
    func showAnimation(_ view : UIView) {
        let pulse = CABasicAnimation.init(keyPath: "transform.scale")
        //pulse.timingFunction = CAMediaTimingFunction.init(name: .easeOut)
        pulse.duration = 0.08
        pulse.repeatCount = 1
        pulse.autoreverses = true
        pulse.fromValue = NSNumber(value: 1)
        pulse.toValue = NSNumber(value: 1.5)
        view.layer.add(pulse, forKey: nil)
    }
    
    /** 当前礼物总数 */
    var currentGiftCount : Int = 0
    
    var completeBlock :((Bool,String)->())?
    /** 返回当前礼物的唯一key */
    var showViewKeyBlock : ((LHGiftModel)->())?
    
    var model : LHGiftModel?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.isHidden = true
        self.setUI()
    }
    
    
    
    private func setUI(){
       
        bgView.frame = CGRect.init(x: 10, y: 0, width: self.frame.size.width - showGiftView_XNum_W - showGiftView_XNum_L , height: showGiftView_GiftIcon_H)
        self.addSubview(bgView)
        
        userIconView.frame = CGRect.init(x: 13, y: showGiftView_UserIcon_LT, width: showGiftView_UserIcon_WH, height: showGiftView_UserIcon_WH)
        self.addSubview(userIconView)
        
        userNameLabel.frame = CGRect.init(x: userIconView.frame.maxX + showGiftView_UserName_L, y: (showGiftView_GiftIcon_H - 2 * showGiftView_UserName_H - 5) / 2, width: showGiftView_UserName_W, height: showGiftView_UserName_H)
        self.addSubview(userNameLabel)
        
        giftNameLabel.frame = CGRect.init(x: userNameLabel.frame.minX, y: 5.0 + (self.userNameLabel.frame.maxY), width: showGiftView_UserName_W * 2, height: showGiftView_UserName_H)
        self.addSubview(giftNameLabel)
        
        self.giftImageView.frame = CGRect.init(x: userNameLabel.frame.maxX, y: 0, width: showGiftView_GiftIcon_W, height: showGiftView_GiftIcon_H)
        self.addSubview(giftImageView)
        
        countLabel.frame = CGRect.init(x: giftImageView.frame.maxX + showGiftView_XNum_L, y: (showGiftView_GiftIcon_H - showGiftView_XNum_H)  / 2, width: showGiftView_XNum_W, height: showGiftView_XNum_H)
        self.addSubview(countLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showGiftShowViewWithModel(_ model : LHGiftModel , completeBlock : ((Bool,String)->())?) {
        self.model = model
        self.isHidden = false
        
        //赋值
        userIconView.image = UIImage(named: "卡哇伊")
        userNameLabel.text = "无忌"
        giftNameLabel.text = "小星星"
        giftImageView.image = UIImage(named: "icon-test")
        
        
        self.completeBlock = completeBlock
        if self.showViewKeyBlock != nil && self.currentGiftCount == 0 {
            self.showViewKeyBlock!(model)
        }
        UIView.animate(withDuration: 0.3) {
            self.frame = CGRect.init(x: 0, y: self.frame.origin.y, width: self.frame.size.width, height: self.frame.size.height)
        }completion: { status in
            self.currentGiftCount = 0
            self.giftCount = model.defaultCount
        }
    }
    
   @objc func hiddenGiftShowView() {
        UIView.animate(withDuration: 0.3) {
            self.frame = CGRect.init(x: -self.frame.size.width, y: self.frame.origin.y - 50, width: self.frame.size.width, height: self.frame.size.height)
        }completion: { status in
            if self.completeBlock != nil {
                self.completeBlock!(true,self.model?.giftKey ?? "")
                self.model = nil
            }
            self.frame = CGRect.init(x: -self.frame.size.width, y: self.frame.origin.y + 50, width: self.frame.size.width, height: self.frame.size.height)

            self.isHidden = true
            self.currentGiftCount = 0
            self.countLabel.text = ""
        }
    }
}
