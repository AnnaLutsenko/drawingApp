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
    @IBOutlet weak var sendBtn: SendButton!
    @IBOutlet weak var viewWithColors: UIView!
    
    @IBOutlet weak var viewUndoCancelBtn: UIView!
    @IBOutlet weak var viewWithMainBtn: UIView!
    
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
    
    func sendBtn(isHidden: Bool) {
        sendBtn.isHidden = isHidden
        viewWithMainBtn.isHidden = isHidden
        viewWithColors.isHidden = !isHidden
        viewUndoCancelBtn.isHidden = !isHidden
    }

    //  MARK: - Actions
    @IBAction func colorSelected(_ sender: UIButton) {
        colorsBtns.forEach { btn in btn.isSelected = false}
        sender.isSelected = true
        let selectedColor = UIColor.init(hex: colorsArr[sender.tag])
        drawView.drawColor = selectedColor
    }

    @IBAction func drawBtnClicked(_ sender: UIButton) {
        viewWithColors.isHidden = false
        sendBtn(isHidden: true)
    }

    @IBAction func undoBtnClicked(_ sender: UIButton) {
        
        drawView.layer.sublayers?.removeLast()
        drawView.layer.layoutSublayers()
    }
    
    @IBAction func doneBtnClicked(_ sender: UIButton) {
        sendBtn(isHidden: false)
    }
}

