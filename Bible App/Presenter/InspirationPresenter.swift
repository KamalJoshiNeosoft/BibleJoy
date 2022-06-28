//
//  InspirationPresenter.swift
//  Bible App
//
//  Created by webwerks on 13/04/20.
//  Copyright © 2020 webwerks. All rights reserved.
//

import Foundation

protocol InspirationDelegate: class {
    func getInspiration(inspiration:[InspirationModel])
    func didGetInspirationFailed(error: ErrorObject)
    func didSetInspiration(isSuccess: Bool, isFav : Int)
}

class InspirationPresenter{
    
    private let inspirationService:InspirationService?
    weak var inspirationDelegate:InspirationDelegate?
    init(inspirationService:InspirationService){
        self.inspirationService = inspirationService
    }
    func showInspiration(){
        inspirationService?.getInspiration(callBack: { (inspirationModel, error) in
            if let error = error{
                inspirationDelegate?.didGetInspirationFailed(error: error)
            }else{
                if let inspiration = inspirationModel{
                    inspirationDelegate?.getInspiration(inspiration: inspiration)
                }
            }
        })
    }
    func showFavoriteInspiration(){
        inspirationService?.getFavoriteInspiration(callBack: { (inspirationModel, error) in
            if let error = error{
                inspirationDelegate?.didGetInspirationFailed(error: error)
            }else{
                if let inspirationfav = inspirationModel{
                    inspirationDelegate?.getInspiration(inspiration: inspirationfav)
                }
            }
        })
    }
    func setFavoriteInspiration(_ inspirationId: Int32,_ isFavorite: Int) {
        inspirationService?.setFavoriteInspiration(withInspirationId: inspirationId, isFavorite: isFavorite, callBack: { (success, error) in
            if let error = error {
                self.inspirationDelegate?.didGetInspirationFailed(error: error)
            } else {
                if let success = success {
                    self.inspirationDelegate?.didSetInspiration(isSuccess: success, isFav: isFavorite)
                }
            }
        })
    }
    
    func getInspirationFavCount() -> Int {
        return inspirationService?.getFavoriteInspirationCount() ?? 0
    }
}
