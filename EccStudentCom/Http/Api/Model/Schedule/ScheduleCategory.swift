//
//  ScheduleCategory.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/06.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import Himotoki

struct ScheduleCategory:Decodable {
    
    let categoryId:Int
    let title:String
    let details:[ScheduleItem]
    
    init(categoryId:Int, title:String, details:[ScheduleItem]) {
        self.categoryId = categoryId
        self.title = title
        self.details = details
    }
    
    static func decode(_ e: Extractor) throws -> ScheduleCategory {
        return try ScheduleCategory(
            categoryId:e<|"category_id",
            title:e<|"title",
            details:e<||"details"
        )
    }
    
}
