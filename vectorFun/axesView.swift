//
//  axesView.swift
//  vectorFun
//
//  Created by Anna Clawson on 5/26/16.
//  Copyright © 2016 Anna Clawson. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable
class AxesView: UIView{
    
    override func drawRect(rect: CGRect){
        let xAxisLength: CGFloat = bounds.width * 0.9
        let yAxisLength: CGFloat = bounds.height * 0.9
        let axisPath = UIBezierPath()
        
        let xLabel = "x"
        let yLabel = "y"
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .Center
        let attrs = [NSFontAttributeName: UIFont(name: "HelveticaNeue-Thin", size: 14)!, NSParagraphStyleAttributeName: paragraphStyle]
        yLabel.drawWithRect(CGRect(x: bounds.width / 2 + 5, y: bounds.height - (bounds.height - 10), width: 20, height: 20), options: .UsesLineFragmentOrigin, attributes: attrs, context: nil)
        xLabel.drawWithRect(CGRect(x: bounds.width - 30, y: bounds.height / 2 + 10, width: 20, height: 20), options: .UsesLineFragmentOrigin, attributes: attrs, context: nil)
        
        axisPath.lineWidth = 1.0
        axisPath.moveToPoint(CGPoint(
            x: bounds.width / 2 - xAxisLength / 2 + 0.5,
            y: bounds.height / 2 + 0.5
            ))
        axisPath.addLineToPoint((CGPoint(
            x: bounds.width - ((bounds.width - xAxisLength)/2),
            y: bounds.height / 2 + 0.5
            )))
        axisPath.moveToPoint(CGPoint(
            x: bounds.width / 2 + 0.5,
            y: bounds.height - ((bounds.height - yAxisLength)/2)
            ))
        axisPath.addLineToPoint((CGPoint(
            x: bounds.width / 2 + 0.5,
            y: 0 + (bounds.height - yAxisLength) / 2
            )))
        UIColor.grayColor().setStroke()
        axisPath.stroke()
    }
    
    
}