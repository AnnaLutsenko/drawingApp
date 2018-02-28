//
//  DrawingViewController.swift
//  DrawingApp
//
//  Created by Anna on 26.02.2018.
//  Copyright © 2018 Anna Lutsenko. All rights reserved.
//

import UIKit

class DrawingViewController: UIViewController {
    
    enum SelectedBtn: Int {
        case textBtn = 0, drawBtn, shapeBtn, imgBtn
    }
    
    @IBOutlet var colorsBtns: [DrawingColorButton]!
    @IBOutlet weak var drawView: DrawView!
    @IBOutlet weak var sendBtn: SendButton!
    @IBOutlet weak var viewWithColors: UIView!
    
    @IBOutlet weak var viewUndoCancelBtn: UIView!
    @IBOutlet weak var viewWithMainBtn: UIView!
    
    var imagePicker: UIImagePickerController!
    
    let colorsArr = ["FFFFFF", "000000", "228AE6", "16AABF", "41C057", "FAB005", "FD7E13", "FA5251", "FF43AD", "BE4ADB"]

    override func viewDidLoad() {
        super.viewDidLoad()
        addGradientToView()
        initController()
    }
    
    func initController() {
        viewWithColors.isHidden = true
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
    }
    
    func addGradientToView() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.black.withAlphaComponent(0).cgColor, UIColor.black.withAlphaComponent(1).cgColor]
        gradient.opacity = 0.2
        gradient.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 70)
        viewWithColors.layer.insertSublayer(gradient, at: 0)
    }
    
    func sendBtn(isHidden: Bool) {
        sendBtn.isHidden = isHidden
        viewWithMainBtn.isHidden = isHidden
        viewWithColors.isHidden = !isHidden
        viewUndoCancelBtn.isHidden = !isHidden
    }
    
    func addImgAsLayer(_ img: UIImage) {
//        drawView.layer.contents = img.cgImage
        let imgLayer = CALayer()
        let myImg = img.cgImage
        imgLayer.frame = drawView.bounds
        imgLayer.contents = myImg
        drawView.layer.addSublayer(imgLayer)
    }

    //  MARK: - Actions
    @IBAction func colorSelected(_ sender: UIButton) {
        colorsBtns.forEach { btn in btn.isSelected = false}
        sender.isSelected = true
        let selectedColor = UIColor.init(hex: colorsArr[sender.tag])
        drawView.drawColor = selectedColor
    }
    
    @IBAction func textBtnClicked(_ sender: UIButton) {
        viewWithColors.isHidden = false
        sendBtn(isHidden: true)
    }

    @IBAction func drawBtnClicked(_ sender: UIButton) {
        viewWithColors.isHidden = false
        sendBtn(isHidden: true)
    }
    
    @IBAction func shapeBtnClicked(_ sender: UIButton) {
        viewWithColors.isHidden = false
        sendBtn(isHidden: true)
    }

    @IBAction func addImgBtnClicked(_ sender: UIButton) {
        let alertController = UIAlertController(title: nil, message: nil , preferredStyle: .actionSheet)
        
        let makePhoto = UIAlertAction(title: "Сделать снимок", style: .default, handler: { action in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        alertController.addAction(makePhoto)
        
        let selectFromGallery = UIAlertAction(title: "Выбрать из галлереи", style: .default, handler: { action in
            self.imagePicker.sourceType = .photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        })
        
        alertController.addAction(selectFromGallery)
        
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController,animated: true, completion: nil)
    }
    
    @IBAction func undoBtnClicked(_ sender: UIButton) {
        drawView.removeLastLayer()
    }
    
    @IBAction func doneBtnClicked(_ sender: UIButton) {
        sendBtn(isHidden: false)
    }
}

extension DrawingViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    //MARK: - Done image capture here
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {return}
        addImgAsLayer(image)
    }
}
