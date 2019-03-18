
import UIKit



class SettingForAnnotationViewController: UIViewController {
  
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var navigationDisplayBarView: UIView!
    @IBOutlet weak var sliderBrush: UISlider!
    @IBOutlet weak var sliderOpacity: UISlider!
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var labelBrush: UILabel!
    @IBOutlet weak var labelOpacity: UILabel!
    @IBOutlet weak var sliderRed: UISlider!
    @IBOutlet weak var sliderGreen: UISlider!
    @IBOutlet weak var sliderBlue: UISlider!
    @IBOutlet weak var labelRed: UILabel!
    @IBOutlet weak var labelGreen: UILabel!
    @IBOutlet weak var labelBlue: UILabel!
  
    var brush: CGFloat = Constants.BRUSH_WIDTH_ANNOTE
    var opacity: CGFloat = Constants.OPACITY_ANNOTE
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
  
  weak var delegate: SettingsViewControllerDelegate?
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    
    sliderBrush.value = Float(brush)
    labelBrush.text = String(format: "%.1f", brush)
    sliderOpacity.value = Float(opacity)
    labelOpacity.text = String(format: "%.1f", opacity)
    sliderRed.value = Float(red * 255.0)
    labelRed.text = Int(sliderRed.value).description
    sliderGreen.value = Float(green * 255.0)
    labelGreen.text = Int(sliderGreen.value).description
    sliderBlue.value = Float(blue * 255.0)
    labelBlue.text = Int(sliderBlue.value).description
    
    drawPreview()
  }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)

    }



  
  // MARK: - Actions
  
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func applyButtonTapped(_ sender: UIButton) {
        delegate?.settingsViewControllerFinished(self )
    }
   
    
  
  @IBAction func brushChanged(_ sender: UISlider) {
    brush = CGFloat(sender.value)
    labelBrush.text = String(format: "%.1f", brush)
    drawPreview()
  }
  
  @IBAction func opacityChanged(_ sender: UISlider) {
    opacity = CGFloat(sender.value)
    labelOpacity.text = String(format: "%.1f", opacity)
    drawPreview()
  }
  
  @IBAction func colorChanged(_ sender: UISlider) {
    red = CGFloat(sliderRed.value / 255.0)
    labelRed.text = Int(sliderRed.value).description
    green = CGFloat(sliderGreen.value / 255.0)
    labelGreen.text = Int(sliderGreen.value).description
    blue = CGFloat(sliderBlue.value / 255.0)
    labelBlue.text = Int(sliderBlue.value).description
    
    drawPreview()
  }
  
    
  func drawPreview() {
    UIGraphicsBeginImageContext(previewImageView.frame.size)
    guard let context = UIGraphicsGetCurrentContext() else {
      return
    }
    
    context.setLineCap(.round)
    context.setLineWidth(brush)
    context.setStrokeColor(UIColor(red: red, green: green, blue: blue, alpha: opacity).cgColor)
    context.move(to: CGPoint(x: 45, y: 45))
    context.addLine(to: CGPoint(x: 45, y: 45))
    context.strokePath()
    previewImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
  }
}

protocol SettingsViewControllerDelegate: class {
    func settingsViewControllerFinished(_ settingsViewController: SettingForAnnotationViewController)
}
