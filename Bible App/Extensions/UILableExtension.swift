//
//  UILableExtension.swift
//  Bible App
//
//  Created by webwerks on 17/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

extension UILabel {

    func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {

        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple

        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

     
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
    }
}

extension UILabel {
    
    func assignAttributedText(stringToBeBold : String, Str1: String, isUnderlined : Bool, fontSize : CGFloat = 12, color : UIColor = .black, linkColor : UIColor = .white) {
        let myAttribute = [NSAttributedString.Key.foregroundColor:color, NSAttributedString.Key.font: UIFont.appRegularFontWith(size: fontSize)]
        let firstString = NSMutableAttributedString(string: self.text ?? "", attributes: myAttribute)
        
        if let range = self.text?.range(of: stringToBeBold)?.nsRange(in: self.text ?? "") {
            firstString.addAttributes([NSAttributedString.Key.foregroundColor:linkColor, NSAttributedString.Key.font: UIFont.appBoldFontWith(size: fontSize)], range: range)
            
        }
        
        if let range1 = self.text?.range(of: Str1)?.nsRange(in: self.text ?? "") {
            firstString.addAttributes([NSAttributedString.Key.foregroundColor:linkColor, NSAttributedString.Key.font: UIFont.appBoldFontWith(size: fontSize)], range: range1)
            
        }
        // set attributed text on a UILabel
        self.attributedText = firstString
    }
    
     
}

