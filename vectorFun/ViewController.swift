//
//  ViewController.swift
//  vectorFun
//
//  Created by Anna Clawson on 5/26/16.
//  Copyright © 2016 Anna Clawson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var mathSceneView: AxesView!
    @IBOutlet weak var matrixView: UIView!
    
    @IBOutlet weak var orangeDot: DraggyCircle!
    @IBOutlet weak var blueDot: DraggyCircle!

    @IBOutlet weak var matrixLabel0: UILabel!
    @IBOutlet weak var matrixLabel1: UILabel!
    @IBOutlet weak var matrixLabel2: UILabel!
    @IBOutlet weak var matrixLabel3: UILabel!
    
    @IBOutlet var matrixFields: [UITextField]!
    @IBOutlet var matrixLabels: [UILabel]!
    
    @IBOutlet weak var orangeDotLabel: UILabel!
    @IBOutlet weak var orangePolarLabel: UILabel!
    @IBOutlet weak var blueDotLabel: UILabel!
    @IBOutlet weak var bluePolarLabel: UILabel!
//    var mathSceneView = UIView()
    
    var labelTriggered: Bool = false
    var triggeredLabelTag = Int()
    var layer = CAShapeLayer()
    var layer2 = CAShapeLayer()
    
    var xCoord = CGFloat()
    var yCoord = CGFloat()
    var productX = Float()
    var productY = Float()
    var BluePolarCoords: (theta: CGFloat, r: CGFloat)?
    var OrangePolarCoords: (theta: CGFloat, r: CGFloat)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        matrixView.userInteractionEnabled = true
        mathSceneView.frame = CGRectMake(0, 20, self.view.frame.width, self.view.frame.height * 0.5)
        blueDot.center = CGPoint(x: mathSceneView.frame.width / 2 + 20, y: mathSceneView.frame.height / 2 + 20)
        orangeDot.center = CGPoint(x: mathSceneView.frame.width / 2, y: mathSceneView.frame.height / 2)
        
        orangeDotLabel.text! = ""
        blueDotLabel.text! = ""
        orangePolarLabel.text! = ""
        bluePolarLabel.text! = ""
        
        for field in matrixFields {
            field.delegate = self
            field.hidden = true
        }
        for label in matrixLabels{
            label.userInteractionEnabled = true
        }
        //        drawPathToCenter()
        self.view.setNeedsDisplay()
    }
    
//  Turn label into editable text field. If a different label was tapped, save the current one and move on to the next label.
    @IBAction func matrixLabelTapped(sender: UITapGestureRecognizer) {
        let tag = (sender.view as! UILabel).tag
        print("Tag: \(tag)")
        if !labelTriggered {
            let label = matrixLabels[tag]
            labelTriggered = true
            label.hidden = true
            label.userInteractionEnabled = false
            let field = matrixFields[tag]
            field.hidden = false
            field.text = label.text
            triggeredLabelTag = tag
        }
        else {
            let prevLabel = matrixLabels[triggeredLabelTag]
            let curLabel = matrixLabels[tag]
            let curField = matrixFields[tag]
            matrixFields[triggeredLabelTag].hidden = true
            prevLabel.hidden = false
            prevLabel.text! = matrixFields[triggeredLabelTag].text!
            prevLabel.userInteractionEnabled = true
            triggeredLabelTag = tag
            curLabel.hidden = true
            curField.hidden = false
            curField.text = curLabel.text
            moveBlueDot()
        }
    }
    
    @IBAction func matrixViewTapped(sender: UITapGestureRecognizer) {
        print(sender.view!)
//  Test whether the view from which tap was received is a label. if not, execute the function.
        if (sender.view as? UILabel) != nil{
        }
        else {
            if labelTriggered {
                let label = matrixLabels[triggeredLabelTag]
                let field = matrixFields[triggeredLabelTag]
                label.hidden = false
                label.userInteractionEnabled = true
                label.text! = field.text!
                field.hidden = true
                label.hidden = false
                labelTriggered = false
                moveBlueDot()
            }
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//  Drag around the orange dot to change vector coordinates
    @IBAction func handlePan(recognizer: UIPanGestureRecognizer){
        
//  Get new position using the recognizer object attached to the dot
        let translation = recognizer.translationInView(self.view)
        if let view = recognizer.view{
            var newPosition = CGPoint(x: recognizer.view!.center.x + translation.x, y: recognizer.view!.center.y + translation.y)
            newPosition.x = min(max(newPosition.x, 0), mathSceneView.bounds.size.width - view.bounds.size.width/2)
            newPosition.y = min(max(newPosition.y, 0), mathSceneView.bounds.size.height - view.bounds.size.height/2)
            // Move orange dot into new position
            view.center = newPosition
            
            xCoord = newPosition.x - (mathSceneView.bounds.width / 2)
            yCoord = mathSceneView.bounds.height / 2 - newPosition.y
            orangeDotLabel.text = "x: \(xCoord), y: \(yCoord)"
            OrangePolarCoords = computePolarCoords(orangeDot)
            orangePolarLabel.text = String(format: "\u{03B8}: %.2f, r: %.2f", OrangePolarCoords!.theta, OrangePolarCoords!.r)
            // After moving the orange dot, recalculate the matrix product and redraw the rest of the moving view elements.
            moveBlueDot()
        }
        recognizer.setTranslation(CGPointZero, inView: self.view)
        drawPathToCenter()
    }
    
    
//  Draw lines from the origin to the two dots
    func drawPathToCenter(){
        layer.contents = nil
        let path = UIBezierPath()
        path.moveToPoint(CGPoint(x: mathSceneView.frame.width / 2, y: mathSceneView.frame.height / 2))
        path.addLineToPoint(orangeDot.center)
        
        
//  Make lines red when the two vectors are colinear
        layer.path = path.CGPath
        if detectColinear() {
            layer.strokeColor = UIColor.redColor().CGColor
        }
        else {
            layer.strokeColor = UIColor(red: 204/255, green: 102/255, blue: 204/255, alpha: 1.0).CGColor
        }
        layer.lineWidth = 1.0
        
        layer2.contents = nil
        let path2 = UIBezierPath()
        path2.moveToPoint(CGPoint(x: mathSceneView.frame.width / 2, y: mathSceneView.frame.height / 2))
        path2.addLineToPoint(blueDot.center)
        
        layer2.path = path2.CGPath
        if detectColinear() {
            layer2.strokeColor = UIColor.redColor().CGColor
        }
        else {
            layer2.strokeColor = UIColor.cyanColor().CGColor
        }
        layer2.lineWidth = 1.0
        
        
        mathSceneView.layer.addSublayer(layer)
        mathSceneView.layer.addSublayer(layer2)
    }
    
    
// Check the coordinates of the location tapped on the screen
    @IBAction func AxesViewTapEvent(sender: UITapGestureRecognizer) {
    }
    
    
//  Calculate dot product of the matrix and the orange dot vector
    func computeMatrixVectorProduct() {
        let matrixVals = [Float(matrixLabel0.text!), Float(matrixLabel1.text!), Float(matrixLabel2.text!), Float(matrixLabel3.text!)]
        productX = xCoord.myFloat * matrixVals[0]! + yCoord.myFloat * matrixVals[1]!
        productY = xCoord.myFloat * matrixVals[2]! + yCoord.myFloat * matrixVals[3]!
    }

    
//  Place blue dot at the dot product coordinate translated into the view coordinate
    func moveBlueDot(){
        computeMatrixVectorProduct()
        let viewX = productX.myCGFloat + mathSceneView.bounds.width / 2
        let viewY = mathSceneView.bounds.height / 2 - productY.myCGFloat
        blueDot.center = CGPoint(x: viewX, y: viewY)
        blueDotLabel.text! = "x: \(productX), y: \(productY)"
        BluePolarCoords = computePolarCoords(blueDot)
        bluePolarLabel.text = String(format: "\u{03B8}: %.2f, r: %.2f", BluePolarCoords!.theta, BluePolarCoords!.r)
    }
    
    
    func computePolarCoords(point: UIView) -> (theta: CGFloat, r: CGFloat){
        let coords = translateToRelativeCoords(point, view: mathSceneView)
        
        let theta = atan2(coords.y.myDouble, coords.x.myDouble)
//        print("Theta: \(theta), y: \(coords.y), x: \(coords.x)")
        let r = sqrt((coords.y * coords.y) + (coords.x * coords.x))
        return(theta.myCGFloat, r)
    }
    
    
    func computeAngleBetweenVectors(point1: UIView, point2: UIView) -> (CGFloat){
        let coords1 = translateToRelativeCoords(point1, view: mathSceneView)
        let coords2 = translateToRelativeCoords(point2, view: mathSceneView)
        let expr = (coords1.x * coords2.x) + (coords1.y * coords2.y) / sqrt(pow(coords1.x, 2) + pow(coords1.y, 2)) * sqrt(pow(coords2.x, 2) + pow(coords2.y, 2))
//        print("coords1: \(coords1), coords2: \(coords2), \(expr)")
        let theta = acos(((coords1.x * coords2.x) + (coords1.y * coords2.y)) / (sqrt(pow(coords1.x, 2) + pow(coords1.y, 2)) * sqrt(pow(coords2.x, 2) + pow(coords2.y, 2))))
        return(theta)
    }
    
    
//  Tanslate coordinates from (0,0) being the top left corner of a view to the center of the view
    func translateToRelativeCoords(point: UIView, view: UIView) -> (x: CGFloat, y: CGFloat){
        return(x: point.center.x - (view.bounds.width / 2), y: (view.bounds.height / 2) - point.center.y)
    }
    
    
//  Check whether the original vector and the vector resulting from multiplication with the matrix are colinear
    func detectColinear() -> Bool{
        let theta = computeAngleBetweenVectors(orangeDot, point2: blueDot)
//        print("Angle between axes: \(theta.roundToPlaces(2)), pi: \(M_PI.roundToPlaces(2))")
        let epsilon: CGFloat = 0.02
        if  (0 - epsilon) ... (0 + epsilon) ~= theta.roundToPlaces(4) || M_PI.roundToPlaces(4).myCGFloat - epsilon ... M_PI.roundToPlaces(4).myCGFloat + epsilon ~= theta.roundToPlaces(2)  {
            return true
        }
        else {
            return false
        }
    }
    
    
}



//Class extensions to make number conversion easier
extension Float {
    var myCGFloat: CGFloat {return CGFloat(self)}
}

extension CGFloat {
    var myDouble: Double {return Double(self)}
    var myFloat: Float {return Float(self)}
    
    func roundToPlaces(places:Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return round(self * divisor) / divisor
    }
}

extension Double {
    var myCGFloat: CGFloat {return CGFloat(self)}
    
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}

