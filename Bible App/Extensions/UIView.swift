//
//  UIView.swift
//  globestamp-ios
//
//  Created by Nuno Gonçalves on 16/04/16.
//  Copyright © 2016 globestamp. All rights reserved.
//

import Foundation
import UIKit
// View
@IBDesignable
class CardView: UIView {
    
     @IBInspectable var shadowOffsetWidth: Int = 0
    @IBInspectable var shadowOffsetHeight: Int = 3
    @IBInspectable var shadowColor: UIColor? = UIColor.black
    @IBInspectable var shadowOpacity: Float = 0.5
     
    override func layoutSubviews() {
         let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
       
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
         layer.borderWidth = CGFloat(borderWidth)
         layer.masksToBounds = false
        
    }
}


extension UIView {
    
//    func hide() {
//        isHidden = true
//    }
//
//    func show() {
//        isHidden = false
//    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set(newValue) {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set(newValue) {
            layer.borderColor = newValue?.cgColor
        }
    }
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set(newValue) {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
    }
    
    func round(corners: UIRectCorner, radius: CGFloat) {
        _round(corners: corners, radius: radius)
    }
    
    func round(corners: UIRectCorner, radius: CGFloat, borderColor: UIColor, borderWidth: CGFloat) {
        let mask = _round(corners: corners, radius: radius)
        addBorder(mask: mask, borderColor: borderColor, borderWidth: borderWidth)
    }
    
    func applyGradientWith(colors: [CGColor]) {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = colors
        layer.insertSublayer(gradient, at: 0)
    }
    
  
      func roundCorners(corners:UIRectCorner, radius: CGFloat) {
          let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
          let mask = CAShapeLayer()
        mask.path = path.cgPath
          self.layer.mask = mask
      }
  
    
    func removeAllSubviews() {
        for v in subviews  {
            v.removeFromSuperview()
        }
    }
    
    func moveMeBy(xOffset: CGFloat, yOffset: CGFloat) {
        frame = frame.offsetBy(dx: xOffset, dy: yOffset)
    }
    
    func moveMeInXBy(_ xOffset: CGFloat) {
        frame = frame.offsetBy(dx: xOffset, dy: 0)
    }
    
    func moveMeInYBy(_ yOffset: CGFloat) {
        frame = frame.offsetBy(dx: 0, dy: yOffset)
    }
    
}

//Mark: - Animations
extension UIView {
    func blink(_ duration: TimeInterval = 0.25) {
        alpha = 0.0
        fadeIn(duration) { [weak self] in
            self?.fadeOut(duration) { [weak self] in
                self?.fadeIn(duration) { [weak self] in
                    self?.fadeOut(duration) { [weak self] in
                        self?.fadeIn(duration)
                    }
                }
            }
        }
    }
    
    func fadeIn(_ duration: TimeInterval, callback: @escaping () -> () = {}) {
        fadeToAlpha(alpha: 1.0, duration: duration, callback: callback)
    }
    
    func fadeOut(_ duration: TimeInterval, callback: @escaping () -> () = {}) {
        fadeToAlpha(alpha: 0.0, duration: duration, callback: callback)
    }

    fileprivate func fadeToAlpha(alpha _alpha: Float, duration: TimeInterval, callback: (() -> ())?) {
        UIView.animate(withDuration: duration,
                                   animations: { [weak self] in self?.alpha = CGFloat(_alpha) },
                                   completion: { state in callback?() }
                                  )
    }
}

fileprivate extension UIView {
    
    @discardableResult func _round(corners: UIRectCorner, radius: CGFloat) -> CAShapeLayer {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
        return mask
    }
    
    func addBorder(mask: CAShapeLayer, borderColor: UIColor, borderWidth: CGFloat) {
        let borderLayer = CAShapeLayer()
        borderLayer.path = mask.path
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.strokeColor = borderColor.cgColor
        borderLayer.lineWidth = borderWidth
        borderLayer.frame = bounds
        layer.addSublayer(borderLayer)
    }
   
}

//Mark: - Constraints
extension UIView {
    
    func constraintToBounds(of view: UIView,
                               constants: (top: CGFloat?, right: CGFloat?, bottom: CGFloat?, left: CGFloat? )? = (0, 0, 0, 0)) {
        let boundAttributes: [NSLayoutConstraint.Attribute] = [.top, .right, .bottom, .left]
        let constants: [CGFloat] = [constants?.top ?? 0, constants?.right ?? 0, constants?.bottom ?? 0, constants?.left ?? 0]
    
        for i in 0..<4 {
            view.addConstraint(buildEqualConstraint(from: view, forAttribute: boundAttributes[i], withConstant: constants[i]))
        }
    }
    
    fileprivate func buildEqualConstraint(from: UIView, forAttribute: NSLayoutConstraint.Attribute, withConstant constant: CGFloat? = 0) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: from,
                                  attribute: forAttribute,
                                  relatedBy: .equal,
                                  toItem: self,
                                  attribute: forAttribute,
                                  multiplier: 1.0,
                                  constant: constant!)
    }
}

extension UIView {

    static func usingAutoLayout() -> Self {
        let anyView = self.init()
        anyView.translatesAutoresizingMaskIntoConstraints = false
        return anyView
    }
    
    class func fromNib<T: UIView>() -> T {
           return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
       }
}
//MARK:- Screenshot
extension UIView {
    func takeScreenshot() -> UIImage {
        // Begin context
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        
        // Draw view in that context
        drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        
        // And finally, get image
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let data = image!.jpegData(compressionQuality: 0)
        let jpgImage = UIImage(data: data!)
        return jpgImage!
    }
}
