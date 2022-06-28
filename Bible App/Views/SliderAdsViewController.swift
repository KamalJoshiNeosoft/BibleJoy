//
//  SliderAdsViewController.swift
//  Bible App
//
//  Created by webwerks on 08/04/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit
class SliderAdsViewController: UIView{
    
    //MARK:-  IBOutlets
    @IBOutlet weak var sideImages:UIImageView!
    @IBOutlet weak var crossButton:UIButton!
    @IBOutlet weak var view:UIView!
     
    //MARK:- Variable Declaration
    var isHomeVC:Bool = true
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        UINib(nibName: "SliderAdsViewController", bundle: nil).instantiate(withOwner: self, options: nil)
        addSubview(view)
        view.frame =  self.bounds
//        sideImages.image =  isHomeVC ?#imageLiteral(resourceName: "BibleMinute"):#imageLiteral(resourceName: "BNDevotion")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
       
    }
    
    @IBAction func imageTap(_ sender:UIButton){
        if isHomeVC{
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.sliderAdHomeClick)
            openUrl(urlString: "https://www.bibleminute.co/free-desktop.php?sub1=Slider4O&sub2=&email=&source=AI&oi=&os=&next=&bc=&panel=default")
        }else{
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.sliderAdDevoClick)
            openUrl(urlString: "https://go.blessuptrk.info/eba44bbf-6eea-4576-b40c-2cb4da908c9c?sub1=Slider2O&sub2=&source=AI")
             UserDefaults.standard.set(true, forKey: AppStatusConst.devotionScreenFloatingViewTap)
        }
    }
    @IBAction func crossButtonTap(_ sender:UIButton){
        self.setView(hidden: true)
        if !isHomeVC{
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.sliderAdDevoClose)
        UserDefaults.standard.set(true, forKey: AppStatusConst.devotionScreenFloatingViewTap)
        } else {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.sliderAdHomeClose)
        }
    }

    private func openUrl(urlString: String!) {
        let url = URL(string: urlString)!        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
extension UIView{
    func setView(hidden: Bool) {
        UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations: {
            self.isHidden = hidden
        })
    } 
}
