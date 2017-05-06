//
//  ScheduleRoot.swift
//  EccStudentCom
//
//  Created by YutaKohashi on 2017/05/06.
//  Copyright © 2017年 YutaKohashi. All rights reserved.
//

import Foundation
import Himotoki

struct ScheduleRoot :Decodable{
    
    let schedules:[ScheduleCategory]
    
    let code:String
    
    let message:String
    
    init(schedules:[ScheduleCategory], code:String, message:String) {
        self.schedules = schedules
        self.code = code
        self.message = message
    }
    
    static func decode(_ e: Extractor) throws -> ScheduleRoot {
        return try ScheduleRoot(
            schedules:e<||"schedules",
            code: e<|"code",
            message: e<|"message"
        )
    }

    
}
