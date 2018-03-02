//
//  DrawingViewController.swift
//  DrawingApp
//
//  Created by Anna on 26.02.2018.
//  Copyright © 2018 Anna Lutsenko. All rights reserved.
//

import UIKit

class DrawingViewController: UIViewController {
    
    let screenSize = UIScreen.main.bounds
    enum SelectedBtn: Int {
        case textBtn = 0, drawBtn, shapeBtn, imgBtn
    }
    var selectedDrawBtn = SelectedBtn.drawBtn
    
    @IBOutlet var colorsBtns: [DrawingColorButton]!
    @IBOutlet weak var drawView: DrawView!
    @IBOutlet weak var pencilBtn: UIButton!
    @IBOutlet weak var sendBtn: SendButton!
    @IBOutlet weak var shapeStackView: UIStackView!
    @IBOutlet weak var viewWithColors: UIView!
    
    @IBOutlet weak var viewUndoCancelBtn: UIView!
    @IBOutlet weak var viewWithMainBtn: UIView!
    
    var imagePicker: UIImagePickerController!
    var tempTextView: UITextView!
    
    let colorsArr = ["FFFFFF", "000000", "228AE6", "16AABF", "41C057", "FAB005", "FD7E13", "FA5251", "FF43AD", "BE4ADB"]
    var selectedColor = UIColor.black

    override func viewDidLoad() {
        super.viewDidLoad()
        addGradientToView()
        initController()
    }
    
    func initController() {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        
        let pencilImg = UIImage(named: "pencilIcon")
        let tintedImage = pencilImg?.withRenderingMode(.alwaysTemplate)
        pencilBtn.setImage(tintedImage, for: .normal)
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
        sendBtn.isEnabled = false
        viewWithMainBtn.isHidden = isHidden
        viewWithColors.isHidden = !isHidden
        viewUndoCancelBtn.isHidden = !isHidden
        sendBtnIsEnabled()
    }
    
    func sendBtnIsEnabled() {
        sendBtn.isEnabled = false
        if let count = drawView.layer.sublayers?.count {
            sendBtn.isEnabled = count > 0
        }
    }
    
    func addImgAsLayer(_ img: UIImage) {
//        drawView.layer.contents = img.cgImage
        let imgLayer = CALayer()
        let myImg = img.cgImage
        imgLayer.frame = drawView.bounds
        imgLayer.contents = myImg
        drawView.layer.addSublayer(imgLayer)
        sendBtnIsEnabled()
    }
    
    func addTextViewToView() {
        tempTextView =  UITextView(frame: CGRect(x: 0, y: 300, width: screenSize.width, height: 500))
        tempTextView.font = UIFont.boldSystemFont(ofSize: 22)
        tempTextView.textColor = selectedColor
        tempTextView.autocorrectionType = .no
        tempTextView.textAlignment = .center
        tempTextView.backgroundColor = .clear
        tempTextView.becomeFirstResponder()
        view.addSubview(tempTextView)
    }
    
    func createCALayerFromTextView() {
        tempTextView.resignFirstResponder()
        guard let text = tempTextView.text else { return }
        
        tempTextView.removeFromSuperview()
        drawView.createLayerWith(text: text, height: tempTextView.getHeight(), width: tempTextView.getWidth())
    }
    
    //  MARK: - Actions
    
    @IBAction func addShape(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            drawView.createSquare(radius: 0)
        case 1:
            drawView.createSquare(radius: 50)
        case 2:
            drawView.createTriangle()
        default:
            return
        }
    }
    
//    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
//        let translation = recognizer.translation(in: self.view)
//        if let view = recognizer.view {
//            view.center = CGPoint(x:view.center.x + translation.x,
//                                  y:view.center.y + translation.y)
//        }
//        recognizer.setTranslation(CGPoint.zero, in: self.view)
//    }
    
    @IBAction func colorSelected(_ sender: UIButton) {
        colorsBtns.forEach { btn in btn.isSelected = false}
        sender.isSelected = true
        selectedColor = UIColor.init(hex: colorsArr[sender.tag])
        pencilBtn.tintColor = selectedColor
        drawView.drawColor = selectedColor
        
        switch selectedDrawBtn {
        case .textBtn:
            tempTextView.textColor = selectedColor
        default:
            return
        }
    }
    
    @IBAction func textBtnClicked(_ sender: UIButton) {
        selectedDrawBtn = SelectedBtn.textBtn
        viewWithColors.isHidden = false
        sendBtn(isHidden: true)
        
        addTextViewToView()
    }

    @IBAction func drawBtnClicked(_ sender: UIButton) {
        selectedDrawBtn = SelectedBtn.drawBtn
        viewWithColors.isHidden = false
        sendBtn(isHidden: true)
    }
    
    @IBAction func shapeBtnClicked(_ sender: UIButton) {
        selectedDrawBtn = SelectedBtn.shapeBtn
        viewWithColors.isHidden = false
        sendBtn(isHidden: true)
        
        shapeStackView.isHidden = false
    }
    
    @IBAction func doneBtnClicked(_ sender: UIButton) {
        sendBtn(isHidden: false)
        sendBtnIsEnabled()
        switch selectedDrawBtn {
        case .shapeBtn:
            shapeStackView.isHidden = true
        case .textBtn:
            createCALayerFromTextView()
        default:
            return
        }
    }
    
    @IBAction func undoBtnClicked(_ sender: UIButton) {
        drawView.removeLastLayer()
        sendBtnIsEnabled()
    }
    
    @IBAction func sendBtnClicked(_ sender: UIButton) {
        let renderer = UIGraphicsImageRenderer(size: drawView.bounds.size)
        let image = renderer.image { ctx in
            drawView.drawHierarchy(in: drawView.bounds, afterScreenUpdates: true)
        }
        print(image)
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
