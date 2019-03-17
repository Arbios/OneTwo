//
//  SecondOutput.swift
//  OneTwoThree
//
//  Created by ARBI BASHAEV on 16/03/2019.
//  Copyright © 2019 ARBI BASHAEV. All rights reserved.
//

import Foundation

enum OutputKeys: Int {
    case price = 34464
    case date = 34465
    var key: String {
        return "\(self.rawValue)"
    }
}

struct SecondOutput {
    private struct Constants {
        static let valueId = "value_id"
        static let value = "value"
    }
    var price: Int?
    var createdAt: String?
    
    init(json: [String: Any]) {
        
        //TODO: сделать кастинг до нужного типа объекта
        if let params = json[OutputKeys.price.key] as? [String: Any],
            let value = params[Constants.value] as? Int {
            price = Int(value)
        }
        
        if let params = json[OutputKeys.date.key] as? [String: Any],
            let value = params[Constants.value] as? String {
            createdAt = value
        }
    }
}

