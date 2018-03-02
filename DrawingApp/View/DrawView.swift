//
//  DrawView.swift
//  DrawingApp
//
//  Created by Anna on 26.02.2018.
//  Copyright © 2018 Anna Lutsenko. All rights reserved.
//

import UIKit

class DrawView: UIView {
    
    var lastPoint: CGPoint!
    var drawColor = UIColor.black
    
    var path = UIBezierPath()
    var currentColor = UIColor.black
    var mySublayers = [CAShapeLayer]()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        path.lineWidth = 5
        lastPoint = touches.first?.location(in: self)
        path.move(to: lastPoint)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let newTouch = touches.first {
            lastPoint = newTouch.location(in: self)
            path.addLine(to: lastPoint)
            self.setNeedsDisplay()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let a = CAShapeLayer()
        a.path = path.cgPath
        a.strokeColor = currentColor.cgColor
        a.fillColor = nil
        a.lineWidth = path.lineWidth
        layer.addSublayer(a)
        
        path = UIBezierPath()
        setNeedsDisplay()
    }
    
    override func draw(_ rect: CGRect) {
        currentColor = drawColor
        drawColor.setStroke()
        path.stroke()
    }

    func removeLastLayer() {
        layer.sublayers?.removeLast()
    }
    
    func createTriangle() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.frame.width/2, y: self.frame.height/2))
        path.addLine(to: CGPoint(x: self.frame.width/2-100, y: self.frame.size.height/2+150))
        path.addLine(to: CGPoint(x: self.frame.width/2+100, y: self.frame.size.height/2+150))
        path.close()
        
        let a = CAShapeLayer()
        a.path = path.cgPath
        a.fillColor = drawColor.cgColor
        layer.addSublayer(a)
    }
    
    func createSquare(radius: Int) {
        let xCoord = CGFloat(self.frame.size.width/2-50)
        let yCoord = CGFloat(self.frame.size.height/2-50)
        
        let path = UIBezierPath(roundedRect: CGRect(x: xCoord, y: yCoord, width: 100, height: 100), cornerRadius: CGFloat(radius))
        
        let a = CAShapeLayer()
        a.path = path.cgPath
        a.fillColor = drawColor.cgColor
        layer.addSublayer(a)
    }
    
    func createLayerWith(text: String, height: CGFloat, width: CGFloat) {
        let a = CATextLayer()
        a.alignmentMode = kCAAlignmentCenter
        a.frame = CGRect(x: (bounds.width-width)/2, y: (bounds.height-height)/2, width: width, height: height)
        let myAttributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 22), NSAttributedStringKey.foregroundColor: drawColor] as [NSAttributedStringKey : Any]
        let myAttributedString = NSAttributedString(string: text, attributes: myAttributes)
        a.string = myAttributedString
        layer.addSublayer(a)
    }
}
