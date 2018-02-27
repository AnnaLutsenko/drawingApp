//
//  DrawingViewController.swift
//  DrawingApp
//
//  Created by Anna on 26.02.2018.
//  Copyright © 2018 Anna Lutsenko. All rights reserved.
//

import UIKit

class DrawingViewController: UIViewController {
    
    @IBOutlet var colorsBtns: [DrawingColorButton]!
    @IBOutlet weak var drawView: DrawView!
    @IBOutlet weak var viewWithColors: UIView!
    
    let colorsArr = ["FFFFFF", "000000", "228AE6", "16AABF", "41C057", "FAB005", "FD7E13", "FA5251", "FF43AD", "BE4ADB"]

    override func viewDidLoad() {
        super.viewDidLoad()
        addGradientToView()
        initController()
    }
    
    func initController() {
        viewWithColors.isHidden = true
    }
    
    func addGradientToView() {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor.black.withAlphaComponent(0).cgColor, UIColor.black.withAlphaComponent(1).cgColor]
        viewWithColors.layer.insertSublayer(gradient, at: 0)
    }

    @IBAction func colorSelected(_ sender: UIButton) {
        colorsBtns.forEach { btn in btn.isSelected = false}
        sender.isSelected = true
        let selectedColor = UIColor.init(hex: colorsArr[sender.tag])
        drawView.drawColor = selectedColor
    }

}

