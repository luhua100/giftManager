# braGiftManager

[![CI Status](https://img.shields.io/travis/luhua100/braGiftManager.svg?style=flat)](https://travis-ci.org/luhua100/braGiftManager)
[![Version](https://img.shields.io/cocoapods/v/braGiftManager.svg?style=flat)](https://cocoapods.org/pods/braGiftManager)
[![License](https://img.shields.io/cocoapods/l/braGiftManager.svg?style=flat)](https://cocoapods.org/pods/braGiftManager)
[![Platform](https://img.shields.io/cocoapods/p/braGiftManager.svg?style=flat)](https://cocoapods.org/pods/braGiftManager)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

  /**弹幕的实现*/
  let  barrageManager = LHBarageManager()
  barrageManager.sourceArray = NSMutableArray.init(array: dataArr)
  barrageManager.startCreatBarrageBlock =  { view in
  view.frame = CGRect.init(x: UIScreen.main.bounds.size.width, y: CGFloat(view.barrageChannel * 40) + 200, width: view.bounds.width + 10, height: view.bounds.height)
  self.view.addSubview(view)
  view.startAnimation()
   }
        
 barrageManager.start()

 /**礼物的实现*/
let model = LHGiftModel()
model.id = "\(arc4random() % 100 + 100)"
model.picPath = self.count % 2 == 0 ? "小新" : "卡哇伊"
let manager = LHMaxGiftManager.shareManager
manager.containerView = self.view
model.giftName = "flower"
model.defaultCount = 0
model.sendCount = 1
LHSmallGiftManager.shareManager.showGiftViewWithBackView(self.view, model) { }


## Installation

braGiftManager is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'braGiftManager'
```

## Author

luhua100, luhua2245@163.com

## License

braGiftManager is available under the MIT license. See the LICENSE file for more info.
