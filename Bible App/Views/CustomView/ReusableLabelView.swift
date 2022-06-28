//
//  ReusableLabelView.swift
//  BibleAppDemo
//
//  Created by Prathamesh Mestry on 14/08/20.
//  Copyright © 2020 prathamesh mestry. All rights reserved.
//

import UIKit

class ReusableLabelView: UIView {
    
    @IBOutlet weak var headerLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fromNib()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupData(text: String) {
        headerLabel.text = text
    } 
}


// Add this Code to Extension file for UIView
extension UIView {
    
    @discardableResult
    func fromNib<T : UIView>() -> T? {
        //https://stackoverflow.com/questions/24857986/load-a-uiview-from-nib-in-swift
        guard let contentView = Bundle.main.loadNibNamed(String(describing: type(of: self)), owner: self, options: nil)?.first as? T else {
            return nil
        }
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        return contentView
    }
}
