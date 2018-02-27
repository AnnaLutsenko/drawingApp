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
    var pathArr: [UIBezierPath] = []
    var currentColor = UIColor.black
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        path.lineWidth = 5.0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if drawColor == currentColor {
            lastPoint = touches.first?.location(in: self)
            path.move(to: lastPoint)
        } else {
            
            let a = CAShapeLayer()
            a.path = path.cgPath
            a.strokeColor = currentColor.cgColor
            a.fillColor = nil
            a.lineWidth = path.lineWidth
            layer.addSublayer(a)
//            layer.insertSublayer(a, at: 0)
//            pathArr.append(path)
            
            path = UIBezierPath()
            path.lineWidth = 5
            lastPoint = touches.first?.location(in: self)
            path.move(to: lastPoint)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let newTouch = touches.first {
            lastPoint = newTouch.location(in: self)
            path.addLine(to: lastPoint)
            self.setNeedsDisplay()
        }
    }

    override func draw(_ rect: CGRect) {
        currentColor = drawColor
        drawColor.setStroke()
        path.stroke()
    }

}
