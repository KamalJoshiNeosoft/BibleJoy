//
//  GradientUIView.swift
//  Bible App
//
//  Created by webwerks on 28/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

class GradientUIView: UIView {
    
    var gradientColors = [UIColor(red: 248/255.0, green: 158/255.0, blue: 100/255.0, alpha: 1.0),UIColor(red: 248/255.0, green: 109/255.0, blue: 36/255.0, alpha: 1.0)]
    var startPoint = CGPoint(x: 0, y: 0.5)
    var endPoint = CGPoint(x: 1, y: 0.5)

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let halfOfButtonHeight = layer.frame.height / 2
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
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 2.0
    }
}

class GradientTable: UITableView {
    
    var gradientColors = [UIColor(red: 248/255.0, green: 158/255.0, blue: 100/255.0, alpha: 1.0),UIColor(red: 248/255.0, green: 109/255.0, blue: 36/255.0, alpha: 1.0)]
    var startPoint = CGPoint(x: 0, y: 0.5)
    var endPoint = CGPoint(x: 1, y: 0.5)

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let halfOfButtonHeight = layer.frame.height / 2
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
        layer.shadowOpacity = 0.15
        layer.shadowRadius = 2.0
    }
}


class BadgeButton: UIButton {

    var badgeLabel = UILabel()

    var badge: String? {
        didSet {
            addbadgetobutton(badge: badge)
        }
    }

    public var badgeBackgroundColor = UIColor.red {
        didSet {
            badgeLabel.backgroundColor = badgeBackgroundColor
        }
    }
    public var badgeTextColor = UIColor.white {
            didSet {
                badgeLabel.textColor = badgeTextColor
            }
        }

        public var badgeFont = UIFont.systemFont(ofSize: 12.0) {
            didSet {
                badgeLabel.font = badgeFont
            }
        }

        public var badgeEdgeInsets: UIEdgeInsets? {
            didSet {
                addbadgetobutton(badge: badge)
            }
        }

    override init(frame: CGRect) {
            super.init(frame: frame)
            addbadgetobutton(badge: nil)
        }

        func addbadgetobutton(badge: String?) {
            badgeLabel.text = badge
            badgeLabel.textColor = badgeTextColor
            badgeLabel.backgroundColor = badgeBackgroundColor
            badgeLabel.font = badgeFont
            badgeLabel.sizeToFit()
            badgeLabel.textAlignment = .center
            let badgeSize = badgeLabel.frame.size


            let height = max(18, Double(badgeSize.height) + 5.0)
                    let width = max(height, Double(badgeSize.width) + 10.0)

                    var vertical: Double?, horizontal: Double?
                    if let badgeInset = self.badgeEdgeInsets {
                        vertical = Double(badgeInset.top) - Double(badgeInset.bottom)
                        horizontal = Double(badgeInset.left) - Double(badgeInset.right)

                        let x = (Double(bounds.size.width) - 10 + horizontal!)
                        let y = -(Double(badgeSize.height) / 2) - 10 + vertical!
                        badgeLabel.frame = CGRect(x: x, y: y, width: width, height: height)
                    } else {
                        let x = self.frame.width - CGFloat((width / 2.0))
                        let y = CGFloat(-(height / 2.0))
                        badgeLabel.frame = CGRect(x: x, y: y, width: CGFloat(width), height: CGFloat(height))
                    }


            badgeLabel.layer.cornerRadius = badgeLabel.frame.height/2
            badgeLabel.layer.masksToBounds = true
            addSubview(badgeLabel)
            badgeLabel.isHidden = badge != nil ? false : true
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            self.addbadgetobutton(badge: nil)
            fatalError("init(coder:) is not implemented")
        }
    }
