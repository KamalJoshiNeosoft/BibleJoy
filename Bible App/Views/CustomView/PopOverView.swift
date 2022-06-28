//
//  PopOverView.swift
//  Bible App
//
//  Created by Kavita Thorat on 26/11/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
import KUIPopOver

class PopOverView: UIView, KUIPopOverUsable {
    
    var onSkip: (() -> ())?
    var onViewNow: (() -> ())? 
    var contentSize: CGSize {
        return CGSize(width: 283, height: 180)
    }
    
    var popOverBackgroundColor: UIColor? {
        return #colorLiteral(red: 1, green: 0.4, blue: 0, alpha: 1)
    }
    
    var arrowDirection: UIPopoverArrowDirection {
        return .up
    }
    
    @IBAction func skipTapped() {
        onSkip?()
    }
    @IBAction func viewNowTapped() {
        onViewNow?()
    }
}
