
//
//  GradientButton.swift
//  Bible App
//
//  Created by webwerks on 28/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

class GradientButton: UIButton {
    
    var gradientColors = [UIColor(red: 248/255.0, green: 158/255.0, blue: 100/255.0, alpha: 1.0),UIColor(red: 248/255.0, green: 109/255.0, blue: 36/255.0, alpha: 1.0)]
    var startPoint = CGPoint(x: 0, y: 0.5)
    var endPoint = CGPoint(x: 1, y: 0.5)
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let halfOfButtonHeight = layer.frame.height / 2
        contentEdgeInsets = UIEdgeInsets(top: 10, left: halfOfButtonHeight, bottom: 10, right: halfOfButtonHeight)
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = UIColor.clear
        
        // setup gradient
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = gradientColors.map { $0.cgColor }
        gradient.cornerRadius = 4
        
        // replace gradient as needed
        if let oldGradient = layer.sublayers?[0] as? CAGradientLayer {
            layer.replaceSublayer(oldGradient, with: gradient)
        } else {
            layer.insertSublayer(gradient, below: nil)
        }
        
        // setup shadow
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: halfOfButtonHeight).cgPath
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowOpacity = 0.85
        layer.shadowRadius = 4.0
    }
}

let themeGradientColors = [UIColor(red: 248/255.0, green: 158/255.0, blue: 100/255.0, alpha: 1.0),UIColor(red: 248/255.0, green: 109/255.0, blue: 36/255.0, alpha: 1.0)]

extension UIButton {
    func useAppGredient(colors : [UIColor] = themeGradientColors) {
        let halfOfButtonHeight = layer.frame.height / 2
        contentEdgeInsets = UIEdgeInsets(top: 10, left: halfOfButtonHeight, bottom: 10, right: halfOfButtonHeight)
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        backgroundColor = UIColor.clear
        
        // setup gradient
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors.map { $0.cgColor }
        gradient.cornerRadius = 4
        
        // replace gradient as needed
        if let oldGradient = layer.sublayers?[0] as? CAGradientLayer {
            layer.replaceSublayer(oldGradient, with: gradient)
        } else {
            layer.insertSublayer(gradient, below: nil)
        }
        
        // setup shadow
        layer.shadowColor = UIColor.darkGray.cgColor
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: halfOfButtonHeight).cgPath
        layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        layer.shadowOpacity = 0.85
        layer.shadowRadius = 4.0
    }
    func setButtonCorner(radious: CGFloat){
        self.cornerRadius = radious
    }
    
    func underline() {
        guard let text = self.titleLabel?.text else { return }
        let attributedString = NSMutableAttributedString(string: text)
        //NSAttributedStringKey.foregroundColor : UIColor.blue
        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: .normal)!, range: NSRange(location: 0, length: text.count))
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: text.count))
        self.setAttributedTitle(attributedString, for: .normal)
    }
    
    func shadowForButton(button: UIButton) {
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 3
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOpacity = 1.0
    }
}
