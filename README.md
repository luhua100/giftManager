# braGiftManager

[![CI Status](https://img.shields.io/travis/luhua100/braGiftManager.svg?style=flat)](https://travis-ci.org/luhua100/braGiftManager)
[![Version](https://img.shields.io/cocoapods/v/braGiftManager.svg?style=flat)](https://cocoapods.org/pods/braGiftManager)
[![License](https://img.shields.io/cocoapods/l/braGiftManager.svg?style=flat)](https://cocoapods.org/pods/braGiftManager)
[![Platform](https://img.shields.io/cocoapods/p/braGiftManager.svg?style=flat)](https://cocoapods.org/pods/braGiftManager)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

  /**弹幕的实现*/
  let  barrageManager = LHBarageManager()\n
  barrageManager.sourceArray = NSMutableArray.init(array: dataArr)\n
  barrageManager.startCreatBarrageBlock =  { view in
  view.frame = CGRect.init(x: UIScreen.main.bounds.size.width, y: CGFloat(view.barrageChannel * 40) + 200, width: view.bounds.width + 10, height: view.bounds.height)\n
  self.view.addSubview(view)\n
  view.startAnimation()\n
   }
  \n      
 barrageManager.start()

 /**礼物的实现*/
let model = LHGiftModel()\n
model.id = "\(arc4random() % 100 + 100)"\n
model.picPath = self.count % 2 == 0 ? "小新" : "卡哇伊"\n
let manager = LHMaxGiftManager.shareManager\n
manager.containerView = self.view\n
model.giftName = "flower"\n
model.defaultCount = 0\n
model.sendCount = 1\n
LHSmallGiftManager.shareManager.showGiftViewWithBackView(self.view, model) { }\n


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
