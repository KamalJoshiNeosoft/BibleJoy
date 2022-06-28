//
//  PrayerPointInfoViewController.swift
//  Bible App
//
//  Created by Kavita Thorat on 21/08/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import UIKit

class PrayerPointInfoViewController: UIViewController {
    
    // MARK:- IBOutlets
//    @IBOutlet weak var addPrayerPoint1Label: UILabel!
//    @IBOutlet weak var addPrayerPoint2Label: UILabel!
//    @IBOutlet weak var addPrayerPoint3Label: UILabel!
//    @IBOutlet weak var usePrayerPoint1Label: UILabel!
//    @IBOutlet weak var usePrayerPoint2Label: UILabel!
//    @IBOutlet weak var infoLabel1: UILabel!
//    @IBOutlet weak var infoLabel2: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var oneTimeBonusButton: UIButton!
    
    // MARK:- Variable Declarations
    var bonusContentClicked: (() -> ())?
    var isFromHome = false


    fileprivate func setupLabels() {
        closeButton.isHidden = !isFromHome
//        addPrayerPoint1Label.assignAttributedString(string1: "\u{2022} Mark a Devotion as Read:", string2: "")
//        addPrayerPoint2Label.assignAttributedString(string1: "\u{2022} Mark a Article as Read:", string2: "")
//        addPrayerPoint3Label.assignAttributedString(string1: "\u{2022} Correctly Answer a Trivia Question:", string2: "")
//        
//        usePrayerPoint1Label.assignAttributedString(string1: "\u{2022} Prayer Booklets -", string2: "")
//        usePrayerPoint2Label.assignAttributedString(string1: "\u{2022} Additional Favorites: ", string2: "")
//        
//        infoLabel1.assignAttributedString(stringToBeBold: "Bonus Content", isUnderlined: true, linkColor:#colorLiteral(red: 0.1843137255, green: 0.5019607843, blue: 0.9294117647, alpha: 1))
//        infoLabel2.assignAttributedString(stringToBeBold: "", isUnderlined: false)
    }
    
    // MARK:- LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLabels()
        
        let isOneTimeClick = UserDefaults.standard.value(forKey: AppStatusConst.oneTimePassword) as? Bool ?? false

        if isOneTimeClick == false {
            oneTimeBonusButton.setTitle("One-Time Bonus", for: .normal)
            
        } else {
            oneTimeBonusButton.setTitle("Start Redeeming Your Points!", for: .normal)
        }
     }
    
    override func viewWillAppear(_ animated: Bool) {
        let isOneTimeClick = UserDefaults.standard.value(forKey: AppStatusConst.oneTimePassword) as? Bool ?? false
        if isOneTimeClick == false {
            oneTimeBonusButton.setTitle("One-Time Bonus", for: .normal)
            
        } else {
            oneTimeBonusButton.setTitle("Start Redeeming Your Points!", for: .normal)
        }
    }
    
    @IBAction func closeInfo(_ sender: UIButton) {
        dismiss(animated: true) {
            self.bonusContentClicked?()
        }
    }

    @IBAction func bonusContentTapped(_ sender: UIButton) {
        
        let isOneTimeClick = UserDefaults.standard.value(forKey: AppStatusConst.oneTimePassword) as? Bool ?? false
        
        if isOneTimeClick == false {
             UserDefaults.standard.set(true, forKey: AppStatusConst.oneTimePassword)
            let prayerPoints = UserDefaults.standard.object(forKey: AppStatusConst.prayerPoints) as? Int
            UserDefaults.standard.set((prayerPoints ?? 0) + 25, forKey: AppStatusConst.prayerPoints)
            UserDefaults.standard.set(1, forKey: AppStatusConst.oneTimeBonusCount)
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: Notification.Name(NotificationName.RefreshPrayerPoints), object: nil)
        }
        
      
        
        if let goToBonus = bonusContentClicked {
            dismiss(animated: true) {
                goToBonus()
            }
        } else {
            TenjinAnalyticsHelper.logEvent(name: TenjinEventConstant.bonusContentClicked)
            if let pager = self.storyboard?.instantiateViewController(withIdentifier: "PagerViewController") as? PagerViewController {
                pager.screenType = .bonus
                self.navigationController?.pushViewController(pager, animated: true)
            }
        }
    }
}

extension UILabel {
    func assignAttributedString(string1 : String, string2 : String) {
        var myAttribute = [NSAttributedString.Key.foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont.appSemiBoldFontWith(size: 14)]
        let firstString = NSMutableAttributedString(string: string1, attributes: myAttribute)
        
        myAttribute[NSAttributedString.Key.backgroundColor] = #colorLiteral(red: 0.04100414366, green: 0.001095706364, blue: 1, alpha: 1)
        myAttribute[NSAttributedString.Key.font] = UIFont.appBoldFontWith(size: 14)

        let secondString = NSAttributedString(string: string2, attributes: myAttribute)
        firstString.append(secondString)

        // set attributed text on a UILabel
        self.attributedText = firstString
    }
    
    func assignAttributedString(stringToBeBold : String, isUnderlined : Bool, fontSize : CGFloat = 17, color : UIColor = .white, linkColor : UIColor = .white) {
        let myAttribute = [NSAttributedString.Key.foregroundColor:color, NSAttributedString.Key.font: UIFont.appRegularFontWith(size: fontSize)]
        let firstString = NSMutableAttributedString(string: self.text ?? "", attributes: myAttribute)
        
        if let range = self.text?.range(of: stringToBeBold)?.nsRange(in: self.text ?? "") {
            firstString.addAttributes([NSAttributedString.Key.foregroundColor:linkColor, NSAttributedString.Key.font: UIFont.appBoldFontWith(size: fontSize)], range: range)
            if isUnderlined {
                firstString.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: range)
            }
        }
        // set attributed text on a UILabel
        self.attributedText = firstString
    }
}

extension RangeExpression where Bound == String.Index  {
    func nsRange<S: StringProtocol>(in string: S) -> NSRange { .init(self, in: string) }
}
