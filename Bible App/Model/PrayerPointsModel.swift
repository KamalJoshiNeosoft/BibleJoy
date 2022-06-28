//
//  PrayerPointsModel.swift
//  Bible App
//
//  Created by webwerk on 31/05/21.
//  Copyright © 2021 webwerks. All rights reserved.
//

import Foundation

struct PrayePointModel: Codable {
    var status: String?
    var data: data
    struct data : Codable{
        var message : String?
    }
}
