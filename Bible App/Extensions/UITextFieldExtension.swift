//
//  UITextFieldExtension.swift
//  Bible App
//
//  Created by webwerks on 08/04/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation
extension UITextField{
  open override func draw(_ rect: CGRect) {
      self.layer.cornerRadius = 9.0
      self.layer.borderWidth = 0.5
      self.layer.borderColor = UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
      self.layer.masksToBounds = true
    }
    
}
extension String
{
    func isValidEmail( ) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: self)
        return result
    }
}
extension UITextField {
    func spacer()  {
        let left  = UIView(frame: CGRect(x: 0, y: 0, width: 6, height: self.frame.height))
        self.leftView = left
        self.leftViewMode = .always
        
        let right  = UIView(frame: CGRect(x: 0, y: 0, width: 2, height: self.frame.height))
        self.rightView = right
        self.rightViewMode = .always
    }
}


extension NSMutableAttributedString {
    
    enum Scripting : Int {
        case aSub = -1
        case aSuper = 1
    }
    
    func scripts(string: String,
                  characters: [Character],
                  type: Scripting,
                  stringFont: UIFont,
                  fontSize: CGFloat,
                  scriptFont: UIFont,
                  scriptFontSize: CGFloat,
                  offSet: Int,
                  length: [Int],
                  alignment: NSTextAlignment) -> NSMutableAttributedString {
        
        let paraghraphStyle = NSMutableParagraphStyle()
        paraghraphStyle.alignment = alignment
        
        var scriptedCharaterLocation = Int()
        
        let attributes = [
            NSAttributedString.Key.font: stringFont,
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.paragraphStyle: paraghraphStyle
        ]
        
        let attString = NSMutableAttributedString(string:string, attributes: attributes)
        
        let baseLineOffset = offSet * type.rawValue
        
        let scriptTextAttributes: [NSAttributedString.Key : Any] = [
            NSAttributedString.Key.font: scriptFont,
            NSAttributedString.Key.baselineOffset: baseLineOffset,
            NSAttributedString.Key.foregroundColor: UIColor.blue
        ]

        for (i,c) in string.enumerated() {
            
            for (theLength, aCharacter) in characters.enumerated() {
                if c == aCharacter {
                    scriptedCharaterLocation = i
                    attString.setAttributes(scriptTextAttributes, range: NSRange(location:scriptedCharaterLocation,
                                                                                 length: length[theLength]))
                }
            }
        }
        return attString
    }
}
