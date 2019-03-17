//
//  Output.swift
//  OneTwoThree
//
//  Created by ARBI BASHAEV on 15/03/2019.
//  Copyright © 2019 ARBI BASHAEV. All rights reserved.
//

import Foundation

struct Output: Codable {
    let createdAt: String
    let camZoom, camZ: Double
    let description: String
    let camAz: Double
    let productionDate: Int
    let updatedAt: String
    let camAy: Double
    let price, calculatedAt: String
    let id: Int
    let thumbnail: String
    let ik: Ik
    let camAx: Double
    let arMode: Int
    let directory: Directory
    let order: Int
    let camY: Double
    let original: Int
    let camX: Double
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case camZoom = "cam_zoom"
        case camZ = "cam_z"
        case description
        case camAz = "cam_az"
        case productionDate = "production_date"
        case updatedAt = "updated_at"
        case camAy = "cam_ay"
        case price
        case calculatedAt = "calculated_at"
        case id, thumbnail, ik
        case camAx = "cam_ax"
        case arMode = "ar_mode"
        case directory, order
        case camY = "cam_y"
        case original
        case camX = "cam_x"
    }
}

struct Directory: Codable {
    let group: Int
    let name: String
    let parent, localParent, localID, type: Int
    let id: Int
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case group, name, parent
        case localParent = "local_parent"
        case localID = "local_id"
        case type, id, icon
    }
}

struct Ik: Codable {
    let inputs: [Put]
    let inputNameCol, sheet, outputValueCol, outputOrderCol: String
    let outputs: [Put]
    let outputStartRow: Int
    let useLocal: Bool
    let inputOrderCol, inputIDCol: String
    let inputStartRow: Int
    let outputIDCol: String
    let directory: Directory
    let inputValueCol, workbook, path, outputNameCol: String
    let id: Int
    let localIkData: String
    
    enum CodingKeys: String, CodingKey {
        case inputs
        case inputNameCol = "input_name_col"
        case sheet
        case outputValueCol = "output_value_col"
        case outputOrderCol = "output_order_col"
        case outputs
        case outputStartRow = "output_start_row"
        case useLocal = "use_local"
        case inputOrderCol = "input_order_col"
        case inputIDCol = "input_id_col"
        case inputStartRow = "input_start_row"
        case outputIDCol = "output_id_col"
        case directory
        case inputValueCol = "input_value_col"
        case workbook, path
        case outputNameCol = "output_name_col"
        case id
        case localIkData = "local_ik_data"
    }
}

struct Put: Codable {
    let nameCell, idCell, value: String
    let id, dirID: Int
    let valueCell, valueID: String
    let isUsed: Bool
    let directory: Directory
    let paramName: ParamName
    let order: Int
    let type, orderCell: String
    let content: [Directory]?
    
    enum CodingKeys: String, CodingKey {
        case nameCell = "name_cell"
        case idCell = "id_cell"
        case value, id
        case dirID = "dir_id"
        case valueCell = "value_cell"
        case valueID = "value_id"
        case isUsed = "is_used"
        case directory
        case paramName = "param_name"
        case order, type
        case orderCell = "order_cell"
        case content
    }
}

enum ParamName: String, Codable {
    case empty = ""
    case height = "height"
    case material = "material"
    case perforation = "perforation"
    case width = "width"
}
