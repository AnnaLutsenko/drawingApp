//
//  DrawingColorButton.swift
//  DrawingApp
//
//  Created by Anna on 26.02.2018.
//  Copyright © 2018 Anna Lutsenko. All rights reserved.
//

import UIKit

class DrawingColorButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 11
        self.layer.borderColor = UIColor.white.cgColor
    }
    
    override var isSelected: Bool {
        didSet {
            layer.borderWidth = isSelected ? 3 : 1
        }
    }

}
