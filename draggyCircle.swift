//
//  draggyCircle.swift
//  vectorFun
//
//  Created by Anna Clawson on 5/26/16.
//  Copyright © 2016 Anna Clawson. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DraggyCircle: UIView{
    @IBInspectable var fillColor: UIColor = UIColor.orangeColor()
    
    override func drawRect(rect: CGRect) {
        let circlePath = UIBezierPath(ovalInRect: rect)
        fillColor.setFill()
        circlePath.fill()
        
    }
}
