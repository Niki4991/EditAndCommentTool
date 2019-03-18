//
//  Constants.swift
//  EditAndCommentTool
//
//  Created by User_218 on 18/03/19.
//

import Foundation
import UIKit
class Constants
{
    static let DRAW_COLOR_ANNOTE = UIColor.black
    static let BRUSH_WIDTH_ANNOTE : CGFloat = 10.0
    static let OPACITY_ANNOTE : CGFloat = 1.0
    static let FONT_SIZE_ANNOTE : CGFloat = 12.0
    static let FONT_FAMILY_ANNOTE : String = "HelveticaNeue"
    static let FONT_BGCOLOR_ANNOTE : UIColor = UIColor.clear
    static let MINIMUM_FONT_SIZE_ANNOTE = 12.0
    static let MAXIMUM_FONT_SIZE_ANNOTE = 36.0
    static let COLOR_PALLET_BORDERCOLOR_ANNOTE = UIColor.black
    static let COLOR_PALLETE_BORDER_WIDTH_ANNOTE = 1.0
    static let KEYBOARD_HEIGHT = 240
}
enum TypesOfAnnotationDrawing {
    case PENCILDRAWING, TEXTADDITION
}
extension UIColor {
    var redValue: CGFloat{ return CIColor(color: self).red }
    var greenValue: CGFloat{ return CIColor(color: self).green }
    var blueValue: CGFloat{ return CIColor(color: self).blue }
    var alphaValue: CGFloat{ return CIColor(color: self).alpha }
}
extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font : font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
