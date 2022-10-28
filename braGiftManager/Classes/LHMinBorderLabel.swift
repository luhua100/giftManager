//
//  LHMinBorderLabel.swift
//  HXStartScram
//
//  Created by zyfMac on 2022/8/4.
//

import UIKit

class LHMinBorderLabel: UILabel {

    var borderColor : UIColor?
    
    override func drawText(in rect: CGRect) {
        let shadowOffset = self.shadowOffset
        let textColor = self.textColor
        
        guard let ref = UIGraphicsGetCurrentContext() else { return  }
        ref.setLineWidth(5)
        ref.setLineJoin(.round)
        ref.setTextDrawingMode(.stroke)
        self.textColor = borderColor
        super.drawText(in: rect)
        
        ref.setTextDrawingMode(.fill)
        self.textColor = textColor
        self.shadowOffset = .zero
        super.drawText(in: rect)
        self.shadowOffset = shadowOffset
    }

}
