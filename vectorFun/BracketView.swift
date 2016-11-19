//
//  File.swift
//  vectorFun
//
//  Created by Anna Clawson on 6/1/16.
//  Copyright © 2016 Anna Clawson. All rights reserved.
//


import Foundation
import UIKit

@IBDesignable
class BracketView: UIView{
    
    override func drawRect(rect: CGRect) {
        let bracketPath = UIBezierPath()
            bracketPath.lineWidth = 3.0
            bracketPath.moveToPoint(CGPoint(x: self.bounds.width / 5, y: 5))
            bracketPath.addLineToPoint(CGPoint(x:10, y: 5))
            bracketPath.addLineToPoint(CGPoint(x:10, y: self.bounds.height - 5))
            bracketPath.addLineToPoint(CGPoint(x: self.bounds.width / 5, y: self.bounds.height - 5))
        
            bracketPath.moveToPoint(CGPoint(x: self.bounds.width - self.bounds.width / 5, y: 5))
            bracketPath.addLineToPoint(CGPoint(x: self.bounds.width - 10, y: 5))
            bracketPath.addLineToPoint(CGPoint(x: self.bounds.width - 10, y: self.bounds.height - 5))
            bracketPath.addLineToPoint(CGPoint(x: self.bounds.width - self.bounds.width / 5, y: self.bounds.height - 5))
        
            UIColor.blackColor().setStroke()
            bracketPath.stroke()
        
        
     }
}

