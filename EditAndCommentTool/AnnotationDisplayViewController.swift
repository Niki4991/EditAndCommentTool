import UIKit

import Photos
import VerticalSlider
import SpriteKit
import GameplayKit
var updatedKeyboardHeightForPotrait : CGFloat = 258
var updatedKeyboardHeightForLandscape : CGFloat = 200
class AnnotationDisplayViewController: UIViewController, FloatyDelegate
{
    
    var lastPoint = CGPoint.zero
    var color = Constants.DRAW_COLOR_ANNOTE
    var brushWidth: CGFloat = Constants.BRUSH_WIDTH_ANNOTE
    var opacity: CGFloat = Constants.OPACITY_ANNOTE
    var fontSize: CGFloat = Constants.FONT_SIZE_ANNOTE
    var fontFamily : String = Constants.FONT_FAMILY_ANNOTE
    var fontBackgroundColor = Constants.FONT_BGCOLOR_ANNOTE
    var swiped = false
    weak var annotationDrawinfDelegate : AnnotationDrawingOnScreenDelegate? = nil
    var firstX : CGFloat = 0
    var firstY : CGFloat = 0
    var eachShapeLayer : CAShapeLayer? = CAShapeLayer.init()
    var addedArrayOfShapeLayer : [CAShapeLayer] = []
    var arrayOfAllDrawingComponents : [[CAShapeLayer]] = []
    var typeOfAnnotationSelected : TypesOfAnnotationDrawing? = nil
    var newLabel : UILabel? = nil
    var arrayOfAllTheAnnotationAddedInScreen :[[CGPoint]] = []
    var imageCaptured : UIImage? = nil
    
    @IBOutlet weak var topConstraintForMainImageView: NSLayoutConstraint!
    @IBOutlet weak var bottomPanelView: UIView!
    @IBOutlet weak var pickerBtn: UIButton!
    @IBOutlet weak var heightConstraintForTexAddition: NSLayoutConstraint!
    @IBOutlet weak var undoBtnOutlet: UIButton!
    @IBOutlet weak var sliderToSetFontSizeForLabel: VerticalSlider!
    @IBOutlet weak var addingDescTextView: UITextView!
    @IBOutlet weak var editDoneBtnOutlet: UIButton!
    @IBOutlet weak var editSettingBtnOutlet: UIButton!
    @IBOutlet weak var editTopPanelView: UIView!
    @IBOutlet weak var drawingPencilBtnOutlet: UIButton!
    @IBOutlet weak var textInputButtonOutlet: UIButton!
    @IBOutlet weak var topButtonPanelView: UIView!
    @IBOutlet weak var closeButtonOutlet: UIButton!
    @IBOutlet weak var downloadButtonOutlet: UIButton!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var colorPallet6: UIButton!
    @IBOutlet weak var colorPallet5: UIButton!
    @IBOutlet weak var colorPallet4: UIButton!
    @IBOutlet weak var colroPallet3: UIButton!
    @IBOutlet weak var colorPallet2: UIButton!
    @IBOutlet weak var colorPalet1: UIButton!
    @IBOutlet weak var normalFontFamilyBtn: UIButton!
    @IBOutlet weak var boldFontFamilyBtn: UIButton!
    @IBOutlet weak var colorPallet7: UIButton!
    @IBOutlet weak var italicFontFamilyBtn: UIButton!
    @IBOutlet weak var colorPallet10: UIButton!
    @IBOutlet weak var colorPallet9: UIButton!
    @IBOutlet weak var colorPallet8: UIButton!
    @IBOutlet weak var drawingToolStackView: UIStackView!
    @IBOutlet weak var drawingToolPanelScrollView: UIScrollView!
    @IBOutlet weak var textYellowHighlightBtn: UIButton!
    @IBOutlet weak var textWhiteHighlightBtn: UIButton!
    @IBOutlet weak var textGreenHighlightBtn: UIButton!
    @IBOutlet weak var textBlueHighlightBtn: UIButton!
    @IBOutlet weak var textOrangeHighlightBtn: UIButton!
    @IBOutlet weak var textRedHighlightBtn: UIButton!
    @IBOutlet weak var textClearHighlightBtn: UIButton!
    @IBOutlet weak var textViewSetupView: UIView!
    @IBOutlet weak var shareAnnotationImageBtn: UIButton!
    
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        //capture image and set
        if let imageCaptured = imageCaptured
        {
            self.mainImageView.image = imageCaptured
        }
        else
        {
            self.mainImageView.image = self.captureScreen()
        }
        
        
        setUpColorSelectionBtn()
    }
    
    
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        if !addingDescTextView.isHidden
        {
            addingDescTextView.becomeFirstResponder()
        }
        
        topConstraintForMainImageView.constant = -(UIApplication.shared.statusBarFrame.height)
        
        //set height for textview
        if UIApplication.shared.statusBarOrientation == .portrait || UIApplication.shared.statusBarOrientation == .portraitUpsideDown
        {
            
            heightConstraintForTexAddition.constant = self.view.frame.size.height -  (editTopPanelView.frame.size.height + bottomPanelView.frame.size.height +  updatedKeyboardHeightForPotrait + UIApplication.shared.statusBarFrame.height)
        }
        else
        {
           
            heightConstraintForTexAddition.constant = self.view.frame.size.height -  (editTopPanelView.frame.size.height + bottomPanelView.frame.size.height +  updatedKeyboardHeightForLandscape + UIApplication.shared.statusBarFrame.height)
        }
       
    }
    
    override var shouldAutorotate: Bool
    {
        return false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

    }
    
    //MARK:- View setup
    func setToDefaultValues()
    {
        lastPoint = CGPoint.zero
        color = Constants.DRAW_COLOR_ANNOTE
        brushWidth = Constants.BRUSH_WIDTH_ANNOTE
        opacity =  Constants.OPACITY_ANNOTE
        fontSize = Constants.FONT_SIZE_ANNOTE
        fontBackgroundColor = Constants.FONT_BGCOLOR_ANNOTE
        fontFamily  = Constants.FONT_FAMILY_ANNOTE
        addingDescTextView.font = UIFont.init(name: fontFamily, size: fontSize)
        addingDescTextView.backgroundColor = fontBackgroundColor
        addingDescTextView.alpha = opacity
        addingDescTextView.textColor = color
        sliderToSetFontSizeForLabel.value = Float(fontSize)
        pickerBtn.tintColor = color
    }
    
    
    func setUpColorSelectionBtn()
    {
        sliderToSetFontSizeForLabel.minimumValue = Float(Constants.MINIMUM_FONT_SIZE_ANNOTE)
        sliderToSetFontSizeForLabel.maximumValue = Float(Constants.MAXIMUM_FONT_SIZE_ANNOTE)
        sliderToSetFontSizeForLabel.value =  sliderToSetFontSizeForLabel.minimumValue
        sliderToSetFontSizeForLabel.addTarget(self, action: #selector(verticalSliderValueChanged), for: .valueChanged)
        self.view.bringSubviewToFront(sliderToSetFontSizeForLabel)
        self.view.bringSubviewToFront(textViewSetupView)
        addingDescTextView.bringSubviewToFront(sliderToSetFontSizeForLabel)
        
        
        
        addingDescTextView.bringSubviewToFront(sliderToSetFontSizeForLabel)
        textViewSetupView.bringSubviewToFront(sliderToSetFontSizeForLabel)
        addingDescTextView.font = UIFont.init(name: fontFamily, size: fontSize)
        addingDescTextView.backgroundColor = fontBackgroundColor
        
        editModeEnableDisable(hideEditting: true)
        addingDescTextView.isHidden = true
        sliderToSetFontSizeForLabel.isHidden = true
        textViewSetupView.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)),
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)),
                                               name: UIResponder.keyboardDidHideNotification, object: nil)
        
        
        colorPalet1.addTarget(self, action: #selector(colorChangeBtnTapped(sender:)), for: .touchUpInside)
        colorPallet2.addTarget(self, action: #selector(colorChangeBtnTapped(sender:)), for: .touchUpInside)
        colroPallet3.addTarget(self, action: #selector(colorChangeBtnTapped(sender:)), for: .touchUpInside)
        colorPallet4.addTarget(self, action: #selector(colorChangeBtnTapped(sender:)), for: .touchUpInside)
        colorPallet5.addTarget(self, action: #selector(colorChangeBtnTapped(sender:)), for: .touchUpInside)
        colorPallet6.addTarget(self, action: #selector(colorChangeBtnTapped(sender:)), for: .touchUpInside)
        colorPallet7.addTarget(self, action: #selector(colorChangeBtnTapped(sender:)), for: .touchUpInside)
        colorPallet8.addTarget(self, action: #selector(colorChangeBtnTapped(sender:)), for: .touchUpInside)
        colorPallet9.addTarget(self, action: #selector(colorChangeBtnTapped(sender:)), for: .touchUpInside)
        colorPallet10.addTarget(self, action: #selector(colorChangeBtnTapped(sender:)), for: .touchUpInside)
        normalFontFamilyBtn.addTarget(self, action: #selector(fontChangeBtnTapped(sender:)), for: .touchUpInside)
        italicFontFamilyBtn.addTarget(self, action: #selector(fontChangeBtnTapped(sender:)), for: .touchUpInside)
        boldFontFamilyBtn.addTarget(self, action: #selector(fontChangeBtnTapped(sender:)), for: .touchUpInside)
        
        colorPalet1.layer.cornerRadius = colorPalet1.frame.size.width/2
        colorPallet2.layer.cornerRadius = colorPallet2.frame.size.width/2
        colroPallet3.layer.cornerRadius = colroPallet3.frame.size.width/2
        colorPallet4.layer.cornerRadius = colorPallet4.frame.size.width/2
        colorPallet5.layer.cornerRadius = colorPallet5.frame.size.width/2
        colorPallet6.layer.cornerRadius = colorPallet6.frame.size.width/2
        colorPallet7.layer.cornerRadius = colorPallet4.frame.size.width/2
        colorPallet8.layer.cornerRadius = colorPallet5.frame.size.width/2
        colorPallet9.layer.cornerRadius = colorPallet6.frame.size.width/2
        colorPallet10.layer.cornerRadius = colorPallet6.frame.size.width/2
        
        //pickerBtn.layer.cornerRadius = pickerBtn.frame.size.width/2
        
        colorPalet1.layer.borderWidth = CGFloat(Constants.COLOR_PALLETE_BORDER_WIDTH_ANNOTE)
        colorPallet2.layer.borderWidth = CGFloat(Constants.COLOR_PALLETE_BORDER_WIDTH_ANNOTE)
        colroPallet3.layer.borderWidth = CGFloat(Constants.COLOR_PALLETE_BORDER_WIDTH_ANNOTE)
        colorPallet4.layer.borderWidth = CGFloat(Constants.COLOR_PALLETE_BORDER_WIDTH_ANNOTE)
        colorPallet5.layer.borderWidth = CGFloat(Constants.COLOR_PALLETE_BORDER_WIDTH_ANNOTE)
        colorPallet6.layer.borderWidth = CGFloat(Constants.COLOR_PALLETE_BORDER_WIDTH_ANNOTE)
        colorPallet7.layer.borderWidth = CGFloat(Constants.COLOR_PALLETE_BORDER_WIDTH_ANNOTE)
        colorPallet8.layer.borderWidth = CGFloat(Constants.COLOR_PALLETE_BORDER_WIDTH_ANNOTE)
        colorPallet9.layer.borderWidth = CGFloat(Constants.COLOR_PALLETE_BORDER_WIDTH_ANNOTE)
        colorPallet10.layer.borderWidth = CGFloat(Constants.COLOR_PALLETE_BORDER_WIDTH_ANNOTE)
        
        //pickerBtn.layer.borderWidth = Constants.COLOR_PALLETE_BORDER_WIDTH_ANNOTE

        colorPalet1.layer.borderColor = Constants.COLOR_PALLET_BORDERCOLOR_ANNOTE.cgColor
        colorPallet2.layer.borderColor = Constants.COLOR_PALLET_BORDERCOLOR_ANNOTE.cgColor
        colroPallet3.layer.borderColor = Constants.COLOR_PALLET_BORDERCOLOR_ANNOTE.cgColor
        colorPallet4.layer.borderColor = Constants.COLOR_PALLET_BORDERCOLOR_ANNOTE.cgColor
        colorPallet5.layer.borderColor = Constants.COLOR_PALLET_BORDERCOLOR_ANNOTE.cgColor
        colorPallet6.layer.borderColor = Constants.COLOR_PALLET_BORDERCOLOR_ANNOTE.cgColor
        colorPallet7.layer.borderColor = Constants.COLOR_PALLET_BORDERCOLOR_ANNOTE.cgColor
        colorPallet8.layer.borderColor = Constants.COLOR_PALLET_BORDERCOLOR_ANNOTE.cgColor
        colorPallet9.layer.borderColor = Constants.COLOR_PALLET_BORDERCOLOR_ANNOTE.cgColor
        colorPallet10.layer.borderColor = Constants.COLOR_PALLET_BORDERCOLOR_ANNOTE.cgColor
        //pickerBtn.layer.borderColor = Constants.COLOR_PALLET_BORDERCOLOR_ANNOTE.cgColor
        
        
        
        colorPalet1.backgroundColor = UIColor.black
        colorPallet2.backgroundColor = UIColor.white
        colroPallet3.backgroundColor = UIColor.red
        colorPallet4.backgroundColor = UIColor.blue
        colorPallet5.backgroundColor = UIColor.green
        colorPallet6.backgroundColor = UIColor.gray
        colorPallet7.backgroundColor = UIColor.magenta
        colorPallet8.backgroundColor = UIColor.orange
        colorPallet9.backgroundColor = UIColor.cyan
        colorPallet10.backgroundColor = UIColor.brown
        
        
        
        
        //text with highlight
        
        textRedHighlightBtn.addTarget(self, action: #selector(textHighlightselected(sender:)), for: .touchUpInside)
        textGreenHighlightBtn.addTarget(self, action: #selector(textHighlightselected(sender:)), for: .touchUpInside)
        textBlueHighlightBtn.addTarget(self, action: #selector(textHighlightselected(sender:)), for: .touchUpInside)
        textWhiteHighlightBtn.addTarget(self, action: #selector(textHighlightselected(sender:)), for: .touchUpInside)
        textOrangeHighlightBtn.addTarget(self, action: #selector(textHighlightselected(sender:)), for: .touchUpInside)
        textClearHighlightBtn.addTarget(self, action: #selector(textHighlightselected(sender:)), for: .touchUpInside)
        textYellowHighlightBtn.addTarget(self, action: #selector(textHighlightselected(sender:)), for: .touchUpInside)
    
    }
    
    
    func performActionForTextAddingEditing()
    {
        typeOfAnnotationSelected = .TEXTADDITION
        editModeEnableDisable(hideEditting: false)
        addingDescTextView.isHidden = false
        sliderToSetFontSizeForLabel.isHidden = false
        textViewSetupView.isHidden = false
        undoBtnOutlet.isHidden = true
        addingDescTextView.becomeFirstResponder()
    }
    
  
    
    
    
    //MARK:- IBACTION

    @IBAction func closeButtonTapped(_ sender: UIButton)
    {
        self.dismiss(animated: true, completion: nil)
        self.annotationDrawinfDelegate?.annotationDisplayPerformed()
    }
    
    @IBAction func downloadAnnotationBtnTapped(_ sender: UIButton)
    {
        if self.mainImageView.image != nil
        {
            UIGraphicsBeginImageContextWithOptions(mainImageView.bounds.size, false, UIScreen.main.scale)
            if let context = UIGraphicsGetCurrentContext()
            {
                mainImageView.layer.render(in: context)
                let imgs = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                if let imageToSave = imgs
                {
                
                     UIImageWriteToSavedPhotosAlbum(imageToSave, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
                    
                  
                }
                
            }
           
        }
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
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
    
    @objc func verticalSliderValueChanged()
    {
        fontSize = CGFloat(Int(sliderToSetFontSizeForLabel.value))
        addingDescTextView.font = UIFont.init(name: fontFamily, size: fontSize)
    }
    
    
    @IBAction func textInputBtnTapped(_ sender: UIButton)
    {
        setToDefaultValues()
        performActionForTextAddingEditing()
        
    }
    
    @IBAction func undoBtnTapped(_ sender: UIButton) {
        if let arrayOfSubLayers = arrayOfAllDrawingComponents.last
        {
            for sublayer in arrayOfSubLayers
            {
                sublayer.removeFromSuperlayer()
            }
            arrayOfAllDrawingComponents.removeLast()
        }
    }
    
    @IBAction func shareAnotationBtnTapped(_ sender: UIButton) {
        
        UINavigationBar.appearance().tintColor = UIColor.black
        
        if self.mainImageView.image != nil
        {
            UIGraphicsBeginImageContextWithOptions(mainImageView.bounds.size, false, UIScreen.main.scale)
            if let context = UIGraphicsGetCurrentContext()
            {
                mainImageView.layer.render(in: context)
                let imgs = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                // set up activity view controller
                let imageToShare = [ imgs ]
                let activityViewController = UIActivityViewController(activityItems: imageToShare , applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
                
                // exclude some activity types from the list (optional)
                activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
                
                // present the view controller
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
    
    
    
    @IBAction func drawingLineInputBtnTapped(_ sender: UIButton) {
        setToDefaultValues()
        typeOfAnnotationSelected = .PENCILDRAWING
        undoBtnOutlet.isHidden = false
        editModeEnableDisable(hideEditting: false)
    }
    
    @IBAction func esitSettingBtnTapped(_ sender: UIButton)
    {
        let settingVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingForAnnotationViewController") as? SettingForAnnotationViewController
        settingVC?.delegate = self
        settingVC?.brush = brushWidth
        if typeOfAnnotationSelected == .TEXTADDITION
        {
            settingVC?.opacity = addingDescTextView.alpha
            settingVC?.red = (addingDescTextView.textColor?.redValue) ?? 0.0
            settingVC?.green = (addingDescTextView.textColor?.greenValue) ?? 0.0
            settingVC?.blue = (addingDescTextView.textColor?.blueValue) ?? 0.0
        }
        else
        {
            settingVC?.opacity = opacity
            settingVC?.red  = color.redValue
            settingVC?.green = color.greenValue
            settingVC?.blue = color.blueValue
        }
        
        self.present(settingVC!, animated: true, completion: nil)
    }
    
    
    @IBAction func editDoneBtnTapped(_ sender: UIButton)
    {
         if typeOfAnnotationSelected == .TEXTADDITION
         {
            addingDescTextView.isHidden = true
            sliderToSetFontSizeForLabel.isHidden = true
            textViewSetupView.isHidden = true
            newLabel =  UILabel.init()
            newLabel?.numberOfLines = 0
            newLabel?.lineBreakMode = .byCharWrapping
            newLabel?.text = addingDescTextView.text ?? ""
            newLabel?.textColor = addingDescTextView.textColor ?? .clear
            newLabel?.font = addingDescTextView.font
            newLabel?.backgroundColor = addingDescTextView.backgroundColor
            newLabel?.alpha = addingDescTextView.alpha
            addingDescTextView.text = ""
            textAddedInAnnotation(textAdded: newLabel!)
            addingDescTextView.resignFirstResponder()
        }
        editModeEnableDisable(hideEditting: true)
        
    }
    
    
    
    @objc func textHighlightselected(sender : UIButton)
    {
        guard let senderBtnColor = sender.backgroundColor else {
            return
        }
        fontBackgroundColor = senderBtnColor
        addingDescTextView.backgroundColor = fontBackgroundColor
//        if let textWithTextView = addingDescTextView
//        {
//            let attributedString = NSMutableAttributedString.init(string: textWithTextView.text)
//            let range = (textWithTextView.text as NSString).range(of: textWithTextView.text)
//            attributedString.addAttribute(NSAttributedStringKey.backgroundColor, value: fontBackgroundColor, range: range)
//            attributedString.addAttribute(NSAttributedStringKey.font, value: textWithTextView.font ?? fontSize, range: range)
//            attributedString.addAttribute(NSAttributedStringKey.foregroundColor, value: textWithTextView.textColor ?? color, range: range)
//            addingDescTextView.attributedText = attributedString
//        }
       
    }
    
    
    
    @objc func colorChangeBtnTapped(sender : UIButton) {
        
        guard let senderBtnColor = sender.backgroundColor else {
            return
        }
        color = senderBtnColor
        pickerBtn.tintColor = color
        addingDescTextView.textColor = color
       
    }
    
    
    
     @objc func fontChangeBtnTapped(sender : UIButton) {
        switch sender.tag {
        case 1:
            fontFamily = "HelveticaNeue"
           
            break
        case 2:
            fontFamily = "HelveticaNeue-Italic"
            
            break
        case 3:
            fontFamily = "HelveticaNeue-Bold"
            break
        default:
           fontFamily = "Helvetica"
        }
        addingDescTextView.font = UIFont.init(name: fontFamily, size: fontSize)
      
    }
    
    //MARK:- update height
    func updateValueForKeyboatdHeight(keyBoardValue : CGFloat)
    {
        if UIApplication.shared.statusBarOrientation == .portrait || UIApplication.shared.statusBarOrientation == .portraitUpsideDown
        {
            updatedKeyboardHeightForPotrait = (keyBoardValue)
        }
        else
        {
            updatedKeyboardHeightForLandscape = (keyBoardValue)
        }
    }
    
    
    //MARK:- Keyboard
    @objc func keyboardWasShown(notification: NSNotification)
    {
        let keyboardSize = ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size)
        updateValueForKeyboatdHeight(keyBoardValue: keyboardSize?.height ?? CGFloat(Constants.KEYBOARD_HEIGHT))
        var aRect : CGRect = self.view.frame
        aRect.size.height -= (keyboardSize?.height) ?? CGFloat(Constants.KEYBOARD_HEIGHT)
        let selectedView = CGRect.init(x: bottomPanelView.frame.origin.x, y: bottomPanelView.frame.origin.y , width: bottomPanelView.frame.size.width, height: bottomPanelView.frame.size.height)
        if !(aRect.contains(selectedView))
        {
            bottomPanelView.frame.origin.y -= (selectedView.origin.y + selectedView.size.height) - (aRect.size.height)
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        let keyboardSize = ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size)
        var aRect : CGRect = self.view.frame
        aRect.size.height -= (keyboardSize?.height) ?? CGFloat(Constants.KEYBOARD_HEIGHT)
        bottomPanelView.frame.origin.y += ((keyboardSize?.height) ?? CGFloat(Constants.KEYBOARD_HEIGHT))
    }
    
    
   
    
    
    //MARK:- drawing tool
    func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint)
    {
        UIGraphicsBeginImageContextWithOptions(mainImageView.frame.size, false, UIScreen.main.scale)
        mainImageView.image?.draw(in: mainImageView.bounds)
        let addedShapeLayer = CAShapeLayer.init()
        addedShapeLayer.strokeColor = color.cgColor
        addedShapeLayer.lineWidth = brushWidth
        addedShapeLayer.fillColor = color.cgColor
        addedShapeLayer.borderColor = color.cgColor
        addedShapeLayer.backgroundColor = color.cgColor
        addedShapeLayer.lineCap = convertToCAShapeLayerLineCap("round")
  
        let path = UIBezierPath()
        path.move(to: fromPoint)
        path.addLine(to: toPoint)
        
        addedShapeLayer.path = path.cgPath
        addedArrayOfShapeLayer.append(addedShapeLayer)
        mainImageView.layer.addSublayer(addedShapeLayer)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    
    func drawtext()
    {
        let textColor = color
        let textFont = UIFont(name: fontFamily, size: fontSize)!
        let textBgColor = fontBackgroundColor
        
        UIGraphicsBeginImageContextWithOptions(mainImageView.frame.size, false, UIScreen.main.scale)
        
        let textFontAttributes = [
            NSAttributedString.Key.font: textFont ,
            NSAttributedString.Key.foregroundColor: textColor,NSAttributedString.Key.backgroundColor: textBgColor
        ] as [NSAttributedString.Key : Any]
        mainImageView.image?.draw(in: mainImageView.bounds)
       
        
        let rect = CGRect(origin: CGPoint.init(x: 100, y: 100), size: (mainImageView.image?.size)!)
        if let text = addingDescTextView.text
        {
            text.draw(in: rect, withAttributes: textFontAttributes)
        }
        
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContextWithOptions(mainImageView.frame.size, false, UIScreen.main.scale)
        mainImageView.image?.draw(in: mainImageView.bounds, blendMode: .normal, alpha: 1.0)
        
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    
    //MARK:- delegates for touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if typeOfAnnotationSelected == nil
        {
            animateTheDisplayOfViews(animateToBottom: false, componentToAnimate: topButtonPanelView, viewHide: true)
            
        }
        else
        {
            animateTheDisplayOfViews(animateToBottom: false, componentToAnimate: editTopPanelView, viewHide: true)
            animateTheDisplayOfViews(animateToBottom: true, componentToAnimate: bottomPanelView, viewHide: true)
        }
        
        if ((touches.first?.location(in: mainImageView)) != nil)  && typeOfAnnotationSelected == .PENCILDRAWING
        {
            guard let touch = touches.first else {
                return
            }
            swiped = false
            addedArrayOfShapeLayer.removeAll()
            lastPoint = touch.location(in: mainImageView)
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if ((touches.first?.location(in: mainImageView)) != nil)  && typeOfAnnotationSelected == .PENCILDRAWING
        {
            guard let touch = touches.first else {
                return
            }
            swiped = true
            let currentPoint = touch.location(in: mainImageView)
            drawLine(from: lastPoint, to: currentPoint)
            lastPoint = currentPoint
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if typeOfAnnotationSelected == nil
        {
            animateTheDisplayOfViews(animateToBottom: true, componentToAnimate: topButtonPanelView, viewHide: false)
            
        }
        else
        {
            animateTheDisplayOfViews(animateToBottom: true, componentToAnimate: editTopPanelView, viewHide: false)
            animateTheDisplayOfViews(animateToBottom: false, componentToAnimate: bottomPanelView, viewHide: false)
        }
        if ((touches.first?.location(in: mainImageView)) != nil) && typeOfAnnotationSelected == .PENCILDRAWING
        {
            if !swiped {
                // draw a single point
                drawLine(from: lastPoint, to: lastPoint)
             
            }
            arrayOfAllDrawingComponents.append(addedArrayOfShapeLayer)
            
            UIGraphicsBeginImageContextWithOptions(mainImageView.frame.size, false, UIScreen.main.scale)
            mainImageView.image?.draw(in: mainImageView.bounds, blendMode: .normal, alpha: 1.0)
            
            mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
         
        }
       
    }
    
    
    
    //MARK: - screenshot and animation
    func captureScreen() -> UIImage?
    {
        //enableDisableEditingViewWithAnimation(hideView: true)
        var window: UIWindow? = UIApplication.shared.keyWindow
        window = UIApplication.shared.windows[0]
        if let windowExist = window
        {
            UIGraphicsBeginImageContextWithOptions(windowExist.frame.size, false, UIScreen.main.scale)
            windowExist.layer.render(in: UIGraphicsGetCurrentContext()!)
            if let image = UIGraphicsGetImageFromCurrentImageContext()
            {
                UIGraphicsEndImageContext()
                let rect = CGRect.init(x: 0, y: -(UIApplication.shared.statusBarFrame.height), width: image.size.width, height: image.size.height + UIApplication.shared.statusBarFrame.height)
                
                // Actually do the resizing to the rect using the ImageContext stuff
                UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
                image.draw(in: rect)
                let newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                return image
            
            }
            
        }
        
        
        return nil
        
    }
    
    
    //MARK:- display features
    func animateTheDisplayOfViews(animateToBottom : Bool, componentToAnimate : UIView, viewHide : Bool)
    {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = convertToOptionalCATransitionSubtype((animateToBottom) ? CATransitionSubtype.fromBottom.rawValue : CATransitionSubtype.fromTop.rawValue)
        componentToAnimate.layer.add(transition, forKey: kCATransition)
        componentToAnimate.isHidden = viewHide
    }
    
    func enableDisableEditingViewWithAnimation(hideView : Bool)
    {
        if hideView
        {
            animateTheDisplayOfViews(animateToBottom: true, componentToAnimate: bottomPanelView,viewHide: true)
        }
        else
        {
            animateTheDisplayOfViews(animateToBottom: false, componentToAnimate: bottomPanelView,viewHide: false)
        }
        
    }
    
    func editModeEnableDisable(hideEditting : Bool)
    {
        if hideEditting
        {
            typeOfAnnotationSelected = nil
            self.editTopPanelView.isHidden = true
            self.topButtonPanelView.isHidden = false
            self.enableDisableEditingViewWithAnimation(hideView: true)
       
            
        }
        else
        {
            self.editTopPanelView.isHidden = false
            self.topButtonPanelView.isHidden = true
            self.enableDisableEditingViewWithAnimation(hideView: false)
          
        }
    }
    
    
    func textAddedInAnnotation(textAdded: UILabel)
    {
        if let textNeedToAdded = textAdded.text
        {
            let heightForLabel = textNeedToAdded.height(withConstrainedWidth: mainImageView.frame.size.width - 10, font: textAdded.font)
            var widthForLabel = textNeedToAdded.width(withConstrainedHeight: mainImageView.frame.size.height - 10, font: textAdded.font)
            if widthForLabel > (mainImageView.frame.size.width - 10)
            {
                widthForLabel = mainImageView.frame.size.width - 10
            }
            let addedLabel = UILabel.init(frame: CGRect.init(x: 0, y: 100, width: widthForLabel, height: heightForLabel))
            addedLabel.text = textAdded.text ?? ""
            addedLabel.numberOfLines = 0
            addedLabel.lineBreakMode = .byCharWrapping
            addedLabel.textColor = textAdded.textColor
            addedLabel.backgroundColor = textAdded.backgroundColor
            addedLabel.font = textAdded.font
            mainImageView.addSubview(addedLabel)
            mainImageView.isUserInteractionEnabled = true
            addedLabel.isUserInteractionEnabled = true
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapGestureForText(_:)))
            tapGesture.numberOfTapsRequired = 1
            addedLabel.addGestureRecognizer(tapGesture)
            let panGesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGestureForTheText(_:)))
            panGesture.maximumNumberOfTouches = 1
            panGesture.minimumNumberOfTouches = 1
            addedLabel.addGestureRecognizer(panGesture)
        }
        
        
        
    }
    
    
    //MARK:- geture recognizer
    @objc func tapGestureForText(_ sender : UITapGestureRecognizer)
    {
        if let changedLabel = sender.view as? UILabel
        {
            addingDescTextView.text = changedLabel.text ?? ""
            addingDescTextView.font = changedLabel.font
            addingDescTextView.backgroundColor = changedLabel.backgroundColor
            addingDescTextView.alpha = changedLabel.alpha
            sliderToSetFontSizeForLabel.value = Float(fontSize)
            addingDescTextView.textColor = changedLabel.textColor
            changedLabel.removeFromSuperview()
            performActionForTextAddingEditing()
        }
    }
    
    @objc func panGestureForTheText(_ sender : UIPanGestureRecognizer)
    {
        if typeOfAnnotationSelected != .PENCILDRAWING
        {
            var translatedPoint = sender.translation(in: self.view)
            
            if sender.state == .began
            {
                firstX = (sender.view?.center.x)!
                firstY = (sender.view?.center.y)!
                
            }
            translatedPoint = CGPoint.init(x: firstX + translatedPoint.x, y: firstY + translatedPoint.y)
            sender.view?.center = translatedPoint
        }
    }
}



extension AnnotationDisplayViewController : SettingsViewControllerDelegate
{
    func settingsViewControllerFinished(_ settingsViewController: SettingForAnnotationViewController) {
        brushWidth = settingsViewController.brush
        opacity = settingsViewController.opacity
        color = UIColor(red: settingsViewController.red,
                        green: settingsViewController.green,
                        blue: settingsViewController.blue,
                        alpha: opacity)
        pickerBtn.tintColor = color
        addingDescTextView.textColor = color
        addingDescTextView.alpha = opacity
        dismiss(animated: true)
    }
}





protocol AnnotationDrawingOnScreenDelegate : class
{
    func annotationDisplayPerformed()
}



// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToCAShapeLayerLineCap(_ input: String) -> CAShapeLayerLineCap {
	return CAShapeLayerLineCap(rawValue: input)
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalCATransitionSubtype(_ input: String?) -> CATransitionSubtype? {
	guard let input = input else { return nil }
	return CATransitionSubtype(rawValue: input)
}
