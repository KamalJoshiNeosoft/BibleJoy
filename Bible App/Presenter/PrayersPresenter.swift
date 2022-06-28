//
//  PrayersPresenter.swift
//  Bible App
//
//  Created by webwerks on 21/01/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation

protocol PrayersDelegate: class {
    func didGetPrayersFailed(error: ErrorObject)
    func didGetPrayers(prayers: [PrayersModel])
    func didSetPrayers(isSuccess: Bool, isFav : Int)
    func didUpdateReadStauts(value:Bool)
}

extension PrayersDelegate {
    func didSetPrayers(prayers: [PrayersModel]) { }
    func didGetPrayers(prayers: [PrayersModel]) { }
}

class PrayersPresenter {
    
    private let prayersService: PrayersService?
    weak var prayersDelegate: PrayersDelegate?
    
    init(prayersService: PrayersService) {
        self.prayersService = prayersService
    }
    
    func showDevotionPrayers() {
        prayersService?.getPrayers(callBack: { [weak self] (prayerList, error) in
            if let error = error {
                self?.prayersDelegate?.didGetPrayersFailed(error: error)
            } else {
                if let prayerArray = prayerList {
                   
                    self?.prayersDelegate?.didGetPrayers(prayers: prayerArray)
                }
            }
        })
    }
    
    func showFavoritePrayers() {
        prayersService?.getFavoritePrayers(callBack: { (prayerList, error) in
            if let error = error {
                self.prayersDelegate?.didGetPrayersFailed(error: error)
            } else {
                if let prayerArray = prayerList {
                    self.prayersDelegate?.didGetPrayers(prayers: prayerArray)
                }
            }
        })
    }
    
    func setFavoritePrayers(_ prayerIds: String,_ isFavorite: Int) {
        prayersService?.setFavoritePrayer(withPrayerId: prayerIds, isFavorite: isFavorite, callBack: { (success, error) in
            if let error = error {
                self.prayersDelegate?.didGetPrayersFailed(error: error)
            } else {
                if let success = success {
                    self.prayersDelegate?.didSetPrayers(isSuccess: success, isFav: isFavorite )
                }
            }
        })
    }
    
    func getPrayersFavCount() -> Int {
        return prayersService?.getFavoritePrayerCount() ?? 0
    }
    func getPrayerReadStatus(prayerId:String){
        
        prayersService?.setUpdateMarkAsRead(PrayerId: prayerId, callBack: { (value, error) in
            if let status = value{
                self.prayersDelegate?.didUpdateReadStauts(value: status)
            }else{
                if let error = error{
                    prayersDelegate?.didGetPrayersFailed(error: error)
                }
            }
            
        })
    }
    func resetPrayerReadStatus(prayerId:String){
        prayersService?.resetUpdateMarkAsRead(prayerId: prayerId)
        
    }
    func resetPrayerTableByMonth(){
        prayersService?.resetPrayerTableOnMonth()
    }
}
