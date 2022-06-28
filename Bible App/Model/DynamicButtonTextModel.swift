//
//  DynamicButtonTextModel.swift
//  Bible App
//
//  Created by webwerk on 06/12/21.
//  Copyright © 2021 webwerks. All rights reserved.
//

import Foundation

struct DynamicButtonTextModel : Codable {
    let status : String?
    let status_code : Int?
    let data : [DynamicButtonData]?

    enum CodingKeys: String, CodingKey {

        case status = "status"
        case status_code = "status_code"
        case data = "data"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        status = try values.decodeIfPresent(String.self, forKey: .status)
        status_code = try values.decodeIfPresent(Int.self, forKey: .status_code)
        data = try values.decodeIfPresent([DynamicButtonData].self, forKey: .data)
    }

}


struct DynamicButtonData : Codable {
    let click_number : Int?
    let type : String?
    let button_text : String?
    let badge : String?
    let internal_name : String?
    let show_sponsored_text : Int?
    let url : String?

    enum CodingKeys: String, CodingKey {

        case click_number = "click_number"
        case type = "type"
        case button_text = "button_text"
        case badge = "badge"
        case internal_name = "internal_name"
        case show_sponsored_text = "show_sponsored_text"
        case url = "url"
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        click_number = try values.decodeIfPresent(Int.self, forKey: .click_number)
        type = try values.decodeIfPresent(String.self, forKey: .type)
        button_text = try values.decodeIfPresent(String.self, forKey: .button_text)
        badge = try values.decodeIfPresent(String.self, forKey: .badge)
        internal_name = try values.decodeIfPresent(String.self, forKey: .internal_name)
        show_sponsored_text = try values.decodeIfPresent(Int.self, forKey: .show_sponsored_text)
        url = try values.decodeIfPresent(String.self, forKey: .url)
    }

}
