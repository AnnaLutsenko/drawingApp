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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        path = UIBezierPath()
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
    }
    
    override func draw(_ rect: CGRect) {
        currentColor = drawColor
        drawColor.setStroke()
        path.stroke()
    }

}
